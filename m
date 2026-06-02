Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83018CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EDAC6B03C9; Tue,  2 Jun 2026 09:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5A76B03CC; Tue,  2 Jun 2026 09:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6029C6B03CD; Tue,  2 Jun 2026 09:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51B116B03C9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:20:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1773F408A4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:20:12 +0000 (UTC)
X-FDA: 84835031064.11.8DF94CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 817881C0010
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:20:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TiCwRUGp;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780406410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OoiGlH/r+jJ1Fp71foigp+gKSr0VX5V5p1UlBTjIHRI=;
	b=ju5V7H3ybsmGz1iLnpVtFwI1F8sc59tPn3gsDR78bvH35sv36ijLQ/T6+y9NtP+TuW5PNL
	FFBjJrR4TgIcqO4Y+NeI2+kxqGyWCUCM44GfElcB1BbT/qG4PtoH/xgFKx4IJc/lYSfgiU
	g4L4rzLXBXx96XK2acJR1z0/JSofbVg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TiCwRUGp;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780406410;
	b=RMAtjZTx23WIpaPYyeNnf+IU+oo/ogG3YCyFs/H4j1un3Qsyr549iUeHLSjhIXS2hKpcHd
	EH8xSn2PfVhCdnRGthPIO000zgBQbxtaBi9aOa9pClRrQBXVNP2UMoVLeS5tYSxJpjq7fm
	IHPoISAai6enjh2tYhKKhEkrXgkPkxc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 039B360123;
	Tue,  2 Jun 2026 13:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0DE1F00893;
	Tue,  2 Jun 2026 13:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780406409;
	bh=OoiGlH/r+jJ1Fp71foigp+gKSr0VX5V5p1UlBTjIHRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TiCwRUGputNHPiFoK4yKcQ6oN01jRdmAcp3CdX792iHHCMwJMptrcP5VHqm7cYS3F
	 rQKQ703VtMw0lHjkdsmzompchUysfmmfXFPZP93HLLW2cYalI0PE2rTV97sHBOhWG9
	 EZRJ8IY44C/+b5lgu5GyO0ytqz3RvjyKaccf9hWfSpqJe5Nf2521fs3JmSGWFJScYa
	 MQzBMNAfHzf90cXhrkzpcjY6q2ZRuoadMGdFVXQozYiVc+LNfXzmur+b6tqyJ2ZAPo
	 IRMN1VeB5o5jKqBrM3pA5di0CEUPWQdeCHANQnmamGu54mg88ldiLcpfmsw/0iy2Rb
	 fmkwDmzqrIkfg==
Date: Tue, 2 Jun 2026 16:20:02 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] memblock: introduce MEMBLOCK_KHO_SCRATCH_EXT
Message-ID: <ah7YgntNsAoFT4v_@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-10-pratyush@kernel.org>
 <agHGOxSnP_VraH1M@kernel.org>
 <2vxzecjhc2s8.fsf@kernel.org>
 <ag-a4ru9bMkDMthO@plex>
 <2vxzse7j7ai9.fsf@kernel.org>
 <ahyDHVSH5eLsnp3C@kernel.org>
 <2vxztsrlds0d.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxztsrlds0d.fsf@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 817881C0010
X-Stat-Signature: ja7xcm6nfmb9d7hq1fbo5msdzhdoc1h8
X-Rspam-User: 
X-HE-Tag: 1780406410-978319
X-HE-Meta: U2FsdGVkX1+7h+YmTcQ05Qgh4h8AdCBUeNEFrQBpMeKQ+biOme+xFsLrEIttU+7LLsin9Lic32v+2xDDOw9vdvWWDMBZjbQI1k4UwskFDwZ9A//9gFv93WkXxKP3wxb0fdSmTi5wO4DSqxB9+MUe2KkcQtjaAO22wWbfQ4TeOk5a7a07oOpnpn8sI9uLHWF8qUgJyCF3I3FWBGwy+/vnvWk6OMXOoJitoL8gTInYhavgplfdzSCQzEL83DpxApSM8PJacyVOR/HaseFt1jZg3bkPIvcElrAwG7UEGwmEHoDtwX86qejrPUjcZMSBClEwVERenTdP9mOiCbytpJ7w/ArK2upIQSXVKfzH1Nohh0d2tD0mISq+H7GfPBK013lPv3gw1HGiiqCWU3smLjpUK9YIeRfmdNRK/U5ivF5Jn+N6D8odJXJyU/ACSdnK5BQXhqV+8jgx6ly3UGp3pj0gFu2+URhQaCsiYavKcN2R1eIOKFzp9IiKEY+GTBU/Kq+bjtty9o8e2stTxNun8xCO10BdxcZFGfai9tZv0oRz1PmJtBsn+PHTNMUIDMetFrTr+8sQfi3yj9ZzKhi0k56IwZoHITzsvCT08JXdXMm7r29dW1Y2uR2TuEpF16I4nKcsez3Pdhp5peSvL6kE3+3fJ1k2yW3hEOtgvmUszjjAiclZ0h3j6xIe+p3CNQzI81BKoNfvGLf6Nj3gvUwu8DblHQXRHdp6WXTMluPRLq5b3ch9bLXFFByA/W2BwBk41wKikh7ilFJiaSo72PNqpC38sbjgt55IQQvK1ZFaVEmm3uMUGAoGvISIKAT6dx309hdc7rK8S+YBpxVKSJED7ZIepYEKUPH9lyvD3o/ODp9hBWD2w/z2xYsgk3oO2JeLgbALtmwX/VdVa1L3/1iXUocA104NS+PVf7SXr8euh1V51/47Kkku8uUq+qFqnu8+qwirb5Oe15NjO03HBizdfR6
 KM3NcW2P
 InEI4moMBFeW4wR/Vk1lm2JjW3l6OWqYDx/ArIsgHX+KNbUmM11IQYDQPdfyjBVTxKI9P/1g3oKTaudrR6o+nJBQqZrIMAKwUWduuHxiAAtKtc7hC+rB4CSKXZKUYTPiYXVmmC+AA1xpCZx3R0FOkJt4B1oMwdWMowT52DjOZ1ze9DPl3kkvP4U2TPatxGGkPsT/N91JxzS7ZINQZz5WSz7MS+mE0Ubct2KdlVZSo/AhcggEn8FiWn0c9UlxmsdZ0zsAdfvp57GJXS6vuEiTa6skB4b6nksiVB5wBjd+BOhNsAKk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 02:52:02PM +0200, Pratyush Yadav wrote:
> On Sun, May 31 2026, Mike Rapoport wrote:
> >> >
> >> > If we want to keep the naming aligned with the existing codebase for now:
> >> > MEMBLOCK_KHO_SCRATCH      -> original scratch
> >> > MEMBLOCK_KHO_UNPRESERVED  -> for the new memory (instead of SCRATCH_EXT)
> >> 
> >> UNPRESERVED sounds good to me. I will use that for the next revision
> >> unless Mike objects.
> >  
> > Can we make it shorter? ;-)
> >
> > UNPRESERVED makes sense, although I'd love to completely remove KHO_ notion
> > and make the name reflect how it's used by memblock. I was toying with
> > PREFERRED instead of SCRATCH, but it didn't feel right enough.
> > With two of them that surely won't work :)
> 
> I don't think you really can remove KHO_ notion. These memory regions
> only make sense on a KHO boot, and won't exist otherwise. And PREFERRED
> sounds like a suggestion/priority hint, not a hard limit. "With KHO
> boot, you can _only_ use PREFERRED memory", doesn't sound right...
> 
> I think MEMBLOCK_KHO_BOOTMEM for scratch and MEMBLOCK_KHO_NOPRESERVE
> (which I think is a tiny bit better than UNPRESERVED) for scratch_ext
> are my top picks. To make it shorter, perhaps MEMBLOCK_KHO_NOPRSRV, in
> similar fashion to RSRV_KERN?

There are a couple of unrelated 'bootmem' things in the kernel, adding
another one shouldn't hurt :)

I like MEMBLOCK_KHO_BOOTMEM and MEMBLOCK_KHO_NOPRSRV the most.
 
> >> would like this series to not get muddled in the naming discussion. I
> >> will use UNPRESERVED for the new concept in v2 though.
> >
> > That might warrant v3 even if everything else is perfect :)
> 
> I can live with that. As long as we can agree on the easy part (the
> code), I don't mind doing another version for the hard part (the naming)
> ;-)

It makes sense to keep KHO_SCRATCH for now and use MEMBLOCK_KHO_NOPRSRV for
the new one to begin with. And then we can ask an LLM do the renaming.
 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

