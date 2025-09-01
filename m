Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D594ECA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16DA68E004C; Mon,  1 Sep 2025 10:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145D18E001A; Mon,  1 Sep 2025 10:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 082B48E004C; Mon,  1 Sep 2025 10:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EACCB8E001A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:28:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 951C9C07BF
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:28:05 +0000 (UTC)
X-FDA: 83840910930.28.0A36492
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id EB1C04000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:28:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YzAQYKzY;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756736884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zx2LRhRNtwc6qV8N+nwIDzHm6RjnubaCShJvOh3SKhY=;
	b=72BiV27CexhkTFqpVxqgPIK1q91dBumBYipv1nd/k5Srn6HQd6G/bpd10RNQMjUaWb7Vuo
	obafTLjCoHeqYiJjuCXuagc+I6kKvkFoSalGtok5o+ycCBKZgFbtKKpLSqYiJlafKJR/ap
	wf+6yrE5urv8KAqv6H+XL+ALVyOEdUY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756736884; a=rsa-sha256;
	cv=none;
	b=8Phy7Vq2ZxYzOorDWe2pD5+etCwsS3sGIHUNqUfLGcyr6qz8zbu1GAn45PEZ3FrVrx0LCN
	O4CJvcAaM2IYP7TExjfKheJ2msSonA80HbNtyzrR1QkjixwVCiZ8qTE9mGGaVVxMKqx1S9
	zOluZDT/7gl2N7SPWDe66KCQ3DjuOww=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YzAQYKzY;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EED144C50;
	Mon,  1 Sep 2025 14:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF62C4CEF0;
	Mon,  1 Sep 2025 14:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756736882;
	bh=79YhD1biW7ZRAbWexbw6r9UIo8+R0Ehi9QzCMPNdDb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YzAQYKzYOdJ3Q71t1i2a14NKnIRG3n/WMD3ZFyAehHTZcJusoFFuNtDI2+HYZCtj4
	 wk4jXKHQxLBdQ/Wwob+BiDoE7bcA3zFC9B0eRyi7Kfl4+gmWXl8HuIHV2Af5e9fgwA
	 k9kw3BDo2FcbU50hWaofq1m8IK+QrX0RmYGl2DNtGvaotpXICnparE35Y4MV2Fgiq5
	 5DMOJp4CNBhGnYB20E8CWFZprn65hFKxKfRI0r2dTONJbvqIUGV2TGTOHgvLj0O5JQ
	 t5EmUEtJBtKDLedgo9+7Jmh8ty/H6KSolSb9QH8nHkMnNj4dqhY7W8+tFatLVLqv3G
	 4q+9NkXdezl/A==
Date: Mon, 1 Sep 2025 17:27:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>,
	"david@redhat.com" <david@redhat.com>,
	"Manwaring, Derek" <derekmn@amazon.com>,
	"Thomson, Jack" <jackabt@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"will@kernel.org" <will@kernel.org>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 04/12] KVM: guest_memfd: Add flag to remove from
 direct map
Message-ID: <aLWtaZYi65aLtTAP@kernel.org>
References: <aLBtwIhQpX6AR2Z6@kernel.org>
 <20250901142220.30610-1-roypat@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901142220.30610-1-roypat@amazon.co.uk>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB1C04000F
X-Stat-Signature: 4kgtab83hq8t6i6u9dff5xrrcj81pofp
X-Rspam-User: 
X-HE-Tag: 1756736883-862490
X-HE-Meta: U2FsdGVkX1//6WNtkwThNuyoIXZ6nd2zu99QP64udmQiWj/yJWanq3YbBH6qz9vlcULeUlyH9SL0Feb1SpU28nRfS0Ns95Zglfi3a4ze7uWYBX9fymf4l738DVq0Sxe9iCX3sJiJg7qM5cdS5bnxDKyVj3to69wTXQOKElJqjmjBMl/rHbcIdtKUpjthTVObjhuZh6huYulvLd9DU7bv7RI7WTTM+FWnjhB9IGbeWclLwZo2O2snDmAuVlPeAVUf4gIM/l2RtNbNeL1pQ6lgYKFSEPz+AXVeWhAeraXwwKQLBfUx01oROT8HgyRQnT9ad6pnhjPEZjXnj4qeDkK5jTlh4lxoDZIdqWVCCAzEP1JUR7yjT1snkUXCop7QruiJll89wokwXQ9S6iRrkCpDqn/KFDHidmsBUp1cPRpSYUOR+jhOmXX5NBIZD2aMATLy1ypAsdcEhwhEzleGhm8ckj+gVpLo1w3Bb5ien1Hci5Hx5iiJhzsbamto7SdOn2bkI7d9Ljp5ip50cz8t8Bxf+uVQkk5lZcZ31/lSTGhlsCzvGq17pG+8hCxm6e0pxDK4lqx84ZZ8xaNpdd/wQL1mT+4h6lDMDhsLSvfHmcIcnirX5NosK50uDIpvBE3pRyRoSpfAPmK4K1kOYsgPG+vTbp/OLKOleaXuOQyDnCL50Cpj11Zg5syvTRizTIMSe9+Sk5xn6OgS4AN0Tt1jfRA4HlLf3vR8s3DA4khKrkB+P3guUElPVf1Qxysx6SduOWxzmSi99pSIUcq+zILu/dvBIn2HAsh22dQ1IF9QFoMKhN0kkOKwWuHQqNMx96JcilE2OFqNzsIZaLhegJcKQodeBsgV2pzKY8wlY7ypfcSDMBa0VbC5nsG1lkT6g3jrZk+0avgMhLSimPDyEs8SaAy2doKyHhxUbvQrM9pJz4eh9v422QFJySTTV3AgEBqDEuKhE0If+n4RVl8qsgoWBw0
 a8v4maYT
 0IGpXNAZtLtGNeBzLuTFIjlXefKeffex1u7iIwqI7Lwbg8XcvbGLa/O8EUKdGObYOv97HrpRI+KWMkghu5wEWtvGrDi/zUxeBgzauAYpj2WFs9K7qBWeJYStjRpPE+f7T1XlTDSergPdhwyMeMk+oM+wSL15bGjc/oBSkihjIz8Eht6kqk8cL/u9nxvSoZot+veDl5je4bf1DGDde2YY+6bgLCTg1FLDLSP1nGGpFi/+PMkIu3rrvxVRBYoUk0ppPsYM59F+TurPVWVcoAbeFY6/w6FuWnmpRMS6cyGqBUdjdi1GYxn5goyztr1q7V2E9OPKpsWlLtpNczM0nP993lmcgzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 02:22:22PM +0000, Roy, Patrick wrote:
> On Thu, 2025-08-28 at 15:54 +0100, Mike Rapoport wrote:
> > On Thu, Aug 28, 2025 at 09:39:21AM +0000, Roy, Patrick wrote:
> >
> >>  static inline void kvm_gmem_mark_prepared(struct folio *folio)
> >>  {
> >> +     struct inode *inode = folio_inode(folio);
> >> +
> >> +     if (kvm_gmem_test_no_direct_map(inode))
> >> +             set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(folio), false);
> > 
> > This may fail to split large mapping in the direct map. Why not move this
> > to kvm_gmem_prepare_folio() where you can handle returned error?
> 
> Argh, yeah, got that the wrong way around. Will update the error handling.
> 
> > I think that using set_direct_map_invalid_noflush() here and
> > set_direct_map_default_noflush() in kvm_gmem_free_folio() better is
> > clearer and makes it more obvious that here the folio is removed from the
> > direct map and when freed it's direct mapping is restored.
> > 
> > This requires to export two symbols in patch 2, but I think it's worth it.
> 
> Mh, but set_direct_map_[default|invalid]_noflush() only take a single struct
> page * argument, so they'd either need to gain a npages argument, or we add yet
> more functions to set_memory.h.  Do you still think that's worth it? 

Ah, right, misremembered that. Let's keep set_direct_map_valid_noflush().
 
-- 
Sincerely yours,
Mike.

