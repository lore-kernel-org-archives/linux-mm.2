Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6375CCF2E5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1C76B027A; Mon, 19 Oct 2026 10:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2506B0288; Mon, 19 Oct 2026 10:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 790776B028A; Mon, 19 Oct 2026 10:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3D66B027A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:39:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA98E1206EB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:39:35 +0000 (UTC)
X-FDA: 85339634310.30.DD92E89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5380D80009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:39:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SqP2OoJA;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792420774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hWQwOt6Wt6hUvhPaeEqwpzhXz566q+fi9LFZingnXA=;
	b=5Jzzzq91ZZW3W+8vHJ7f5TFDXBwdHs8l2+9cO/r921LDzw4Dpc2IyhgBfqi+M+P/vkYYmR
	O5nHpzylalwgmnp7M5ynDsyMFNGQ7qYPJpzdr+HKJtMjbjcf3v2WryEXkIlRB4gcAGS9pY
	wUz4HnVNUC1D67QQ1m3ZZAa/eMoyhXo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792420774;
	b=NwI+XaH3TP/wqqX7yLpXrhhVz1Zrabfa4Fe4XgmMz+/y9n0fi4oW51kXmuRXhKMDTrmm72
	EAXZO1WuWvYzTS494eCZ/v5pipAQR2X/mT4q+Hq+8HtCqYn6lqDA7GwgIq+vfJkCIKIMOC
	BEI64tbE/o7lwWxGcP9N2dXo5eEowXw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SqP2OoJA;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9F9560136;
	Mon, 19 Oct 2026 14:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D093D1F000C9;
	Mon, 19 Oct 2026 14:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792420773;
	bh=6hWQwOt6Wt6hUvhPaeEqwpzhXz566q+fi9LFZingnXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SqP2OoJAFz60lu3Rxyx877dqP4vCGu83HkFx6suWTPAyerC//e6zk6twRwt21ZMx7
	 zgixhHQs1hfKO682iB+0Pltr1tbYACHSji4rD7I/XelqVCa5LcqGFUNT+Mn48Szaaz
	 fglHf9x8Ut/vDzhqy662N9OYXACbtTLlpy5lXZfoNinvN9jSAdEJG9CaO2wycP7yaT
	 Pj9of5A8NTLxrc5jFBXihvJ7U69ApwvgERUW67lxByxCk4zz5u90YU9sbq9ciVUJY+
	 KQZkWIDeRf97J0ulxABT2LeDJ64On/Jljx41whei3vhE8FXRgzde9EyltPEdDkAs/I
	 WBz2K4WlSGEWA==
Date: Mon, 19 Oct 2026 15:39:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Daehyeon Ko <4ncienth@gmail.com>
Subject: Re: [PATCH v2] mm/vma: avoid spurious write locks when
 mm->mm_lock_seq overflows
Message-ID: <atYqIrlyW1tgZJIx@gremlin>
References: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
 <atXjbsDn7DJybsHU@pedro-suse.tail5790ac.ts.net>
 <atYJA7nIu_RwpoCC@gremlin>
 <20261019073201.aee381fbbdf2edfdd0a68754@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019073201.aee381fbbdf2edfdd0a68754@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5380D80009
X-Stat-Signature: n6mfdastrshp5b3uhx8bagdopfkiphsu
X-Rspam-User: 
X-HE-Tag: 1792420774-10461
X-HE-Meta: U2FsdGVkX1+VGxZ2Oa1vAM9TFYD7x1zw35p0tkGsfh8Y1focuug59WrTNReO8fy0r8F0tlZe53HHgXdLwNNIoyHaO/I7DZ4BZv5hixa9NudyBzBqpRBPmvfhhUCGugKnvoREwDd7awh4N/Q9IoAdhTDlzxW/D2TXPxoB1rnXBPngswTZd2HbpW6OjJYskrpw5m0KYyroOBb0wR3u0eF0c/SvVqeIKj8mfh9fJaZbtxBQLYHI4m3sILJht6CDXo6yptuCUcQHkFwNONgIZ3DyrVZafy/D8YhNoDbZdHJcmgNL1jsYG59Xu6QSwYXVr6mmUqpzK3aOtGx/llUBXvpVHnyIYhotl2M+FJmEx3a9kbAH//G+Fzmt6R0KsZMx4k1CdCzA0iu/K0SWKS+4AIP1XrThZMyJIgTn0B/SJ5vTu1tl0Z4+YxjfhtAxJETuuW+bQt2j8jt2ADXxK1xZo3ut25RzYZllj9JS8wH8Pr3U6OCcUPspCPqkH2wFzaYRgCww5zKXYwf+89VP4M1TfwVkA4IvgGgCx0w63ATbgIiyIUFYDZ/w8PuPnPbNa7njDZo4n7FI/xSiEwHj7Ybf4op2jaL0ZR2ai2LXJYtStZLXgJE2XQuZa76IGDda5g7udqZZID3pKqmIIT3ekxZ4+913gRgNlOIt2NSu9KfnzAY8OzoUIOXkfP2sSaxSsvXaaRtoEcnxHzl7rWe3RW+NAJ2+RBEC5Lc26krgULxrNiA2EAS+F4lnM0MEAhkVnAO27SU+BleChd2mJ2rgqCX+9A5yfuvMNgsTHga748SOGfvmpysSS8vgzh34CFr4Snz59hpHDPVgaY5BZ40IztX5AXpeYaaA/woEcZXDNM1Rj4afGHxPfP9OPIeu8Eia3ZjgWqu16ZHLFBmzH7r2uR8Xhlun7ew5SCrN5sCfhvCrQZIPVx7ZyhSjn3c3mQNoAFqSjB0TRb2/42x5nLCw+FLRRIF
 yN7ZC6o9
 e1NU1vF0xswhvuPDR4J+6+ADPIvvCbgSqnPGA53gox3z02qQjOcTSC4Ac0juk2yt4k8EGv18rMHozJcEO6m167ArqyigE7IZdFgvfqGl61dttAC/fB/Kz7Ln17/AO8pjp/OwiarWrYeuQ+ftXL3Qd2XLDoyPCxR31MtOu5PkdgioGksbIvDk8lPNdrrunvs0xgyNrNUXz2HhzQ4CGHEzftSEDDCW6JNB6UVCOGS8vWeHqDCNf3QGR3r6fv0qY3EUl8UhnrvyL/qpizag5Bus4FwDbcswwLuqkc9kp2QQcZpsOvX3winuxsRxVO6I9i8aYxS+/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 07:32:01AM -0700, Andrew Morton wrote:
> On Mon, 19 Oct 2026 13:19:45 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > On Mon, Oct 19, 2026 at 10:53:27AM +0100, Pedro Falcato wrote:
> > > On Fri, Oct 16, 2026 at 12:34:33PM +0100, Lorenzo Stoakes (ARM) wrote:
> >
> > > > So I think it's fine to just send it (early :) in the merge window.
> > > > ---
> > > > v2:
> > > > * Updated comment in vma_seqcount_is_write_locked() to mention the VMA
> > > >   being attached.
> > > > * Renamed reset_vma_seqcounts() to __mm_reset_vma_seqcounts().
> > > > * Used acquire semantics in vma_start_reads() to avoid race with reset -
> > > >   there is another acquire immediately after this one so it should just be
> > > >   noise perf-wise.
> > > > * Removed stable tag, will do the backports manually (just make the value
> > > >   64 bits...)
> > >
> > > I guess you're fitting this where __vm_anon_pgoff_lo now sits? If so, then
> > > this patch probably wants backporting to 7.3.
> >
> > Ack.
>
> I added cc:stable to the mm.git copy of this.

But that'll trigger the bots for every revision right? I don't want that, even
if they fail, that'll set off Sasha's bot who might get things spectacularly
wrong.

Could you update it to:

Cc: <stable@vger.kernel.org> # v7.3.x

To be super clear about it.

Thanks!

--
Cheers, Lorenzo

