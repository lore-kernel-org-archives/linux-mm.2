Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE7ECDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ED396B00AE; Wed, 24 Jun 2026 11:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49DCB6B00B5; Wed, 24 Jun 2026 11:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C0F6B00B7; Wed, 24 Jun 2026 11:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15E4F6B00AE
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:34:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9262BC1A61
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:34:20 +0000 (UTC)
X-FDA: 84915202680.18.BBD5A11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 96F1740012
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:34:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oRI0U7+d;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782315258;
	b=Sy6IYZH/gxMtbRNJ4Osn9HxfWLslQ9v1kI0SlqeBRoYV2oG1/1Lt0G2KLvtS8BgGJjjfA2
	jyKjvcGDDZCf7kUynlhI8W04bpSRUs4hukk3cDCgvVtsT0afLqSPU5Vurq0zaloCn6YQ5g
	A4OWSlim3FWVBTNX1H2lQA2M5FgFo4M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782315258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hxR4MG/qC5C8YyJjFUoDWnC/FyP8VpBZ0QmBHCym7Jc=;
	b=4Bcu49t9vZVu1dMgCiRbO8acMqetFjZEivDnpDRSJidslodIT3qANbCa/ElJFON4KXcF6B
	04eLR8+pm3RXvpoFNXbAElOLZAocjBXy7/TiLsj6oq9d1tmLCKugrznavNtvp1H9IYnNrc
	GjrbLaEuUIKm3k0noB1DYGRUjWm2sfo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oRI0U7+d;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0063C60139;
	Wed, 24 Jun 2026 15:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A251F00A3D;
	Wed, 24 Jun 2026 15:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782315257;
	bh=hxR4MG/qC5C8YyJjFUoDWnC/FyP8VpBZ0QmBHCym7Jc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oRI0U7+d4pDvzhfYUK1ed+TuSP5oghlfHZo0Su1F8FxcdICNXkSeSs4DY/RV372/o
	 powMOBdz/tTa8MLO0R7OzQCtxyDqxaTFkoRaOqLMQKqp34jrVsP0XdO7GtBYdZTCQ+
	 qziKov0A/GLsw4Ww7xn6UzY0UcWJN200TayYN3bl4Fa4bYkRu6wAb36MQoHAldCiWE
	 3fZBcDM53S7l89CPo09IRBNubMDrBRQvmOtuYhnWDQKOsPmLGkP0WaP0Bbux1+MTGZ
	 u/W1b+x0BSb7mJyFQ7OhuTpYd1EzozihuwnT56qe/2g8I5KI6sQ1cdFukFXJlYoD/O
	 WC5C0aB2gvsTw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 864ACF4008D;
	Wed, 24 Jun 2026 11:34:16 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 24 Jun 2026 11:34:16 -0400
X-ME-Sender: <xms:-Pg7apme-oZDbyuGaEUN5Op5XWL5n7xmJo5oozSBV7ASo1sMmqKInA>
    <xme:-Pg7allbFYE6YdZtOlFQsAGIbXcJ2_tDM7VLz4A_qvZDpKOX2Fl9R71glXkL987tc
    9_xusqjuBh07ObGr_Jwjm1pAM8uKd61DOtC3yEXgLrrE2FHMeadrnM>
X-ME-Received: <xmr:-Pg7ajcaKx7ZAzReo78iP-2l2yBGDEJaZfiDQ-xWZxqQCD-dSF_MSJ4wr1OV3g>
X-ME-Proxy-Cause: dmFkZTGOIvn2FHCIv9d9YkVJJGv81JNLCBT/TRG37/WouSujzdHvrC/9eKmXzopoMq9cZN
    3CcYHSrqxQp2QnX1h+cq/mkb627F0jaHqwepJxFmYc09ZirIu8o2TR9B/S3eHBvTFYLQKe
    eCNWJxZ9wkRG3GBuTLa5Amg8Ny1KjCXGf3L5T7TM101iROV1LQpHdvbL7eWENMsvtQUkIG
    Z0vWDVdpnuG9YuFHOgRQ3gdOk6wWCTg3tJHtut7C+m4ZDf+18jfhCqVQkgNwe5r1R//JJl
    PbPIxUb5rBU9iyIkzsl24TwZOz8XGSSYuF+XHKtNipFfv2O/n/1Q5bCGBNpA55zvAI5AZ6
    IT4SfaN7a7/1QCgzGPrwFPV3TTsNF0cnRb7irdZpL1JENLpexq9QKsHREPv1COyZW+wwlq
    2jBzOxF5zaz0O2gjTTOYVk6tdQP2RjGsu6ybwanZnizXrtYtnVQL7Qn/qkBHV8KLacuKkt
    nN9Naz6CsVFJRLSqOh79qEOFBers3GyBnON1FoV2wb0vEtHnfaig9tbWEuSWImQXNfdOTx
    odObJryI73zsQMZOiTAg9QPLjOT/3M1bQVgwRYQ5iLfobU3ZZj9sujfs/RVYUjHOElu+6q
    qSF+KhVUW1Aozd/8jDIBI/p7OC117a9bZB04bR4EFk0p3lr0cFHt+1E3472Q
X-ME-Proxy: <xmx:-Pg7arJBtciKspEuJnYrXi1UUnSdNcyn8GYHbIMwzH5tkwNml0L4TQ>
    <xmx:-Pg7am7Y0OkC1V4VD02SnveZJa-s2iffSRjaZ3y0-i4OTCGkFXYK1Q>
    <xmx:-Pg7aiQhOf0vptyHv0cX_gqsemRLvHmkg6Uj8wpCYlxfwlQUjg5lUA>
    <xmx:-Pg7aut13OMmgfcT9zyNJ0y2jq3AQwkrcp8ioZ7C-4DYYZO3sz5Geg>
    <xmx:-Pg7amQCNCFMSIeq1bxFMenPNrVYvkxA5z0_wwhAqRru_dQ7VAgSTp3M>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Jun 2026 11:34:14 -0400 (EDT)
Date: Wed, 24 Jun 2026 16:34:08 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, nao.horiguchi@gmail.com, 
	linmiaohe@huawei.com, david@kernel.org, lance.yang@linux.dev, 
	akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, pratyush@kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, rneu@meta.com, riel@surriel.com, 
	caggio@meta.com
Subject: Re: mm/hwpoison: persist poisoned PFN list across kexec via KHO [RFC]
Message-ID: <ajv4f4_m2rQ3hpoW@thinkstation>
References: <ajut_LDQGYCShApx@gmail.com>
 <aju5_WjBtagTOSJw@thinkstation>
 <ajvzUg8KK9gtFTYe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajvzUg8KK9gtFTYe@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 96F1740012
X-Stat-Signature: bu9eaof8jow5qaw4tj67kmzg93wdc4gi
X-HE-Tag: 1782315258-182857
X-HE-Meta: U2FsdGVkX18IUvIgI1XQtkO5tDgcAC4aCt0b1/4kKCxeEfldz8l/l+dP16avjxzKDGMV03lTQMemFEfWpIpEoD66exyRNLd1JXKsaVXTvspgaXupKzh9HNnDns5WZew8j0IRCrY6tUegV5yzj5WoJVBDyA7jTjieYwuBgrO78gxfQ/+Vk9cPcF6GjLGDGk1qPbnmRbN2UHY+N+NpZXAfIMNfWz/CN8YMCKA9QFhU+g6QNetXOMBV0dVvxNombdKmQJDEKjdyG6BFPg8rNtx8uEvjazuUcFCdjRGRXC7AM79q24mctNbjcZoBKVRW1DpEGk7DY0p2Fnvhc5vgFWHbJffGclwujW8H3w+73quvH2bRzo/I6i9Lm+TDPxOR7I9OefIvs19Np1kZ9YToM1PcZJIGPYOXkNL4Gh5dFg18Fs4w+Cu6HoeZ4u4uW4N14LpjVfMf3CFG8lOHAckcplYGvHMsXVtb2y2bkDvTcYxx1Iig3Abdkvhu5cd9D9pEoW9GIpnLe1qj3e1E4i50wOB/COR43K8Vd7JndoRIvLv7owwRTMqKgmbBbq5jwVoZK05hwdXi3yu8VcgCGjHAE//A9tOQR83PM8SUUWnkdXMU9NnN07Sel/O+w/5w9iMg9kbGCHrMsnsNYRKZfdqe2Q31gErm09gkBPEtFk+pRJlAcb6Gnm2ck50bAutagcAIGbBEBHcXaUtczyD7hSVm9IP8lOTTQLdKA+Luq63eh87uki3y/0EJOeADeW/Qadyhi2bQjTEhaao2+jZ/4Jh0kBksyXfZf3QDolq6LIrFBdHtYNZ3o+bCBJS4AzWnr1OjmXYjB7sgxmX0DVGxScnfUxceDI9JaHZ0KSvoPqzyYYQbQLC10Me+jZjL7h6QqiIR6fq8VjzdzPRuGYbHC4X6LnoDoNTapIhc55DW1kPsUWPcnN1tvWdmRD9a8FlxfvPz18iiwclZ6wm524cOAydamZe
 XDHARb51
 kGCSdPmtNJnKq8c3a1pk6qU/vQ6Sr719NcXcTkH2G2IbaRfc4CcIl+K6zgwIbbegr6h7ErPp+O6aAESdrMXjvp4vwl50ITTr7MjakscITRshwlfUIrj9Q0W9G3TsEosq3rcFQkpR4lV41l2zAkLpwCBL+ppBF2i9LxhB2Ib+HV5O7fvCJ8o7sQ8NPsup9TMYgUp81acyq1WRAdmHBRtbT5mnRpn7tXONQdiGOUp1m7MFwCk+5Rp6q3p+xmaHLpkLjW0JlbDBwKSDCl8kWYcEkd6GRY985+VsCKSpMjAHUrO/+Tvx2H3BCPv3y9/FT7xi3D7Iwkrh4vnBS0TNJVsjBeFbJt47XvwBOagc5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 08:21:16AM -0700, Breno Leitao wrote:
> > > Possible solutions
> > > ==================
> > ...
> > > 
> > > 2. e820 / EFI memory map (E820_TYPE_UNUSABLE). Tempting because the
> > >    frame would simply never become RAM (no allocator race at all).
> > >    But: it is x86-only (no arm64 equivalent in the same mechanism;
> > >    this series is tested on arm64);
> > 
> > (+Ard. I might get some details around EFI wrong.)
> > 
> > This isn't accurate, and I think it's the right direction for EFI
> > platforms. EFI_UNUSABLE_MEMORY is honored on both arches today, no new
> > consumer code:
> > 
> >   - arm64: reserve_regions() marks non-usable memory nomap.
> 
> Is it true for non-UEFI arm64 hosts?

No. It is EFI-only thingy.

Is there non-EFI server platforms worth caring about?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

