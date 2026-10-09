Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41B7CCA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 154CD6B008A; Fri,  9 Oct 2026 07:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105FF6B008C; Fri,  9 Oct 2026 07:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01AD56B0092; Fri,  9 Oct 2026 07:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D352E6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:52:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 575B280365
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:52:51 +0000 (UTC)
X-FDA: 85302926142.18.65DE918
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C4DA0140006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:52:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EmmMOlTu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791546769;
	b=j725IOEBMFdxTBMC9b7CqQz/+LqpfZlFMb192SS4Z+JhEZtS03rywfSmlBcKy7FJokzWhv
	CcbXf1KuUaNEGwY0H9rqKACDW3YTxc4BRXR0s0CPtVORL1ByNpaaCnEj3TZHwBm0mtp4It
	YNqrEpaqy6+94f45b9FsqJ0WmHRjZ/A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EmmMOlTu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791546769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPaxLapLIH/2EyNGK1S6Kb5H2+5cvD20ZEOmkko0hkA=;
	b=gV48kzOyqmjKhKkPRrBGW4okIKxYShXPDyJ4aBkCn/OKe6dyOPqms2Rejo1FcqpwqSECiD
	Ts4PvKp2Ie50KVnZ8fg9KrxtEBal+/2Svb2NGYx+yud/WRKjLSyEX+PQp5vGdBitMzmSlS
	8Zr1la5OBf8bl4NQHjA3ZvShQ+ErNnM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D53660DBD;
	Fri,  9 Oct 2026 11:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D24A1F000FF;
	Fri,  9 Oct 2026 11:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791546768;
	bh=MPaxLapLIH/2EyNGK1S6Kb5H2+5cvD20ZEOmkko0hkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EmmMOlTuplEeuow4t4xT6vfDJs++UDA+9Iy3DZRwR/KKje4t4byk3Is7Wuf7f9y0i
	 AhQfbE2HtbpAby4CLjECGQjpZUOqavTotVpsRRPVQmkKj2Q53FauYRAvjcpwcMvpSn
	 f0pp1MR/dxefBD0cDo7mkpkQIID03DjVhXDxJwt3lxy6n0RsjioFcvXPPVgdEFSrlp
	 aQ1zsm2o63O3JSFtdNCUCJ79fA4aN61tex2rnJ+6uF7BZ62Xb4BqsVgDOVM7q8JG9i
	 KX3TU1JnBAax+VugXLxZxKa1fD+Jy+AMbxaLmniuXMCmlanA21ucKPi7HbeOsXbk2M
	 w1E7vTentQszg==
Date: Fri, 9 Oct 2026 12:52:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>, akpm@linux-foundation.org, muchun.song@linux.dev, 
	osalvador@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: avoid recursive i_mmap_rwsem in PMD sharing
Message-ID: <asjVUa6XBZ8ti-0_@gremlin>
References: <20260930064308.58159-1-lizhe.67@bytedance.com>
 <arzVaC2IYkqSb0_U@gmail.com>
 <9a7c026e-f5f2-40e0-84aa-919c988cc136@bytedance.com>
 <2b4571c5-8e51-4c91-9d88-11929f200875@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b4571c5-8e51-4c91-9d88-11929f200875@kernel.org>
X-Stat-Signature: mdao8jof4in6hejhwk1o9q7kbyt5gk71
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C4DA0140006
X-HE-Tag: 1791546769-812527
X-HE-Meta: U2FsdGVkX1+vEcXLGbqVf47EsF50UVmDV8OfkH+8PbSqytPDSEEWsSHmGIfop3m/6nE9T6X5bpMJ2I2vnR3hatqNosH4WaWdhm2HnZJ0yOgK4rGbrqV6WxXjaZzuRxYsbrPPEOSa6z15oEPEPCN3fgCMxNdIDRH7s/X551bhwwZMbDqZogZJFCBsTD2QMWLKYpe6UQW3b8ijT+Fdap3nGtBYdFRsXhuQ+OKXYp0Ht29wxHMNBfZgb/wmue6IsDETs77WFMJ/xhc+sOSqp+bTC1p2YGbvrkx07kYHkDSpjcWJLTkwdbkViav7ijNT5UqDo1wu8+uVNhrmMFdLzftvy5/mQV1XoldWsCqSzepmfgkQR7IN0t/CgtTqOm5LSQO+GNpXk91UBiosAPLBc8RhNdgco86KbU9gZ35VjFSI3hQayQljXvQ8DuMwUXC/A+ctZC4yrobkB1f43HqO+f3X0b3FN+UavVhG3qtrcv+vaY6I37CegtygdNANCVim43vWQayajdbJR1QFZ4v0EZK33mu538bH+fQE/sHO0oMc/7V70M9y6yI9y4uk1VqfhcoZFFnPbr/JDwBf//ELlVUrCIa4kGqtD38kKUFW7xQYK8GgKpK/ovZE9GAdYPsrkU5nscy996gOkDjwCyrCXqvdxbMSWinycgxLxDeRxeAsLwcwAp2SnDKF4GhLapLpdP2Kv/fgoPD459HqwxyygMsyi6kqqvcYp6z5ysX+oX5qCf2HfS5Lb1tBgLtmqgRYcJwY79JtL8M3a73oBBcOJf8YDiXZcDonAEwfAun5z+PQo7ZF8kUt2jSwoIrmmrTKwbgvbT+9ZBkblxhtQ03ys+rXDtInY1lXhb3nr7RRN1bWhZL2kTTIa/G9Nif9ATJpb29w1hOmZsx+N5nInIQTDEq8fA5tvCEBRt5PMvTpVcM7RAE5fCALLe5/s1SdtFnfOPwgRvDLGorbnzPSgjewlRY
 onQjwvyw
 oeh9fU8i1fyKiPW8NVDQUjaZwVud4++7SnGOwG3cjZOIAvrDYzVyXumvaVRl101OjYdqU9ukJ2HiAVJgfQqFs5PSwc5LDSQ2xlA2Ow+/0Ahd4jNlyuqpmvEAZ9MaxELW/XkcmgimlSKUT7qggiqr1xjYm4I2Ov2eMQTtHf54ji6Ytjs3hwZHO8daXArPZFgbGf0P69aJvwrO2Z1pzGCcku/k+iIm45EPmAdJHDCxv8IQRn2iF/GqLDcvD3gLqJHTNBBIl/7CkIsuhzFJ4noJLV69yZqJrXzLDfrSIjro4sG7J8nA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 05, 2026 at 11:25:01AM +0200, David Hildenbrand (Arm) wrote:
> > David mentioned that Oscar was planning to send a proper fix for this
> > issue, so I will wait for that patch instead of moving forward with this
> > trylock fallback approach.
> @Lorenzo, if Oscar is too busy, I guess we can paste the overall idea for the
> fix here as well (publicly)?

Yeah I don't see why not! I don't think there's anything that needs to be
private here.

--
Cheers, Lorenzo

