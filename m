Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ABA3C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679B86B00A6; Mon, 21 Sep 2026 08:36:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603706B00CF; Mon, 21 Sep 2026 08:36:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518FF6B00DD; Mon, 21 Sep 2026 08:36:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 383726B00A6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:36:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 689DC160178
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:36:28 +0000 (UTC)
X-FDA: 85237717656.03.8C17405
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C80144000D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:36:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J4kZcT/a";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J4kZcT/a";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789994186;
	b=VJrdQEM8/EJf2RTNOYSvZgkBwfLB5ohXzE7oJqM5rWCqvHXJDkWLb0QE4gP/NtbxI/tUKM
	dFmzaOfwVEhQiBMsRMU4pU4rskhMDonKVQf+fdyV6xaz5ihGYcLTnJuCPkl1tgTFPM6Do9
	wTECiABxG0xHTxC5hGlhvJGoZFl3A2g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789994186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNbuG7YPUwGnu291NOoq4XdEL23SA/SC4CBEZ8BBaao=;
	b=sLDdcNmSkLsEH/4VBt1WU8hr0Uyr3MBzl9P+jZ3mLYPxthO/z0hVwns5g6dYYcpvc7RM2s
	PywhXqifLbtStxpMffCTzzS/u6dNq7IUDSI7QWrBH+dIp+oSDGTaRcjMagazJ82n/3g218
	2p3MXK01nYFTS3eI57DWuzsmQJX/miM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D54F40F00;
	Mon, 21 Sep 2026 12:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCA11F0089B;
	Mon, 21 Sep 2026 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789994185;
	bh=gNbuG7YPUwGnu291NOoq4XdEL23SA/SC4CBEZ8BBaao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J4kZcT/agr85+vQTRPO233PzvBZdNcYdc9+PRXc22BN55hbaj489UjHHrfv7tn7/K
	 fAa2t+HMjrQ+dc3JOdsQHbVcASn0zUPBE2WYw5y9+6qPS+sSjV4ICZAGgksfeSfDxN
	 YNvCPHfUsB9MpPtHXui5NWmkzGUnFdhCSxZyvMhIXMjOGanY/Q3rphkD3arRuPREsP
	 Tk20IursSjtYecT5UGLnGDT1J5PPDN9cwqgPHvWQBegoeTfdU+VKwiln1DNLdHaLSn
	 MVRF7s5ToVYRBETbJfEFa/EzwL1ehQ5sawvhgK0XCLuD4SS/H+JLPs3akF1tZO+Gp1
	 Ibk6OwvVFwRTA==
Date: Mon, 21 Sep 2026 13:36:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yuan-Hao Hsu <aa9736195201@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, liam@infradead.org, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Barry Song <baohua@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/memory: reuse the whole exclusive large folio
 on a write fault
Message-ID: <arEkcIb7JQFd4zzI@gremlin>
References: <8cbbc303-59a5-49f6-bc14-28fbb58350f0@kernel.org>
 <20260919111843.656-1-aa9736195201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919111843.656-1-aa9736195201@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C80144000D
X-Stat-Signature: 6h9p8wkqor5fckkz7xateoikzhrgxsik
X-Rspamd-Server: rspam01
X-HE-Tag: 1789994186-55607
X-HE-Meta: U2FsdGVkX1/wbw0Yupwatpi9HZ4G/TSF9zX2kyRl8w/XtOgNZD1/dWrt5NtjB37gnT1sEEmcwoCwzSnNsEQKNmCvNE8+ZafG9q4YyMKH++z4Lv5qI5valisznYSEiDRPy08mF0nLrlJa68k4AXgQpj5e6XxtIgie/4og9FwDAYpfgFrTHG1NGMD/r5CCdER0USrgQ70F6sikuizHCi7ZV7QMtwn7yjU4jwV+dF8s+IMCkNktawC2dxTTxFvwb0oo2il7NjyXtVaYiPjwH0eb/Zjo+w1kxgnA+VJ8NMPU8KLJVhlUxM11k4zfaxAfxObYdFTBkPTP3SmhxEqV3PYOTsyrrcLdLlHATnHCsHFR60FUKyKGq/H2FNBfPnipQ+o/PLY8DHxHuMG725ejV1pkoSLFUE0eGPTX4u4MKCSlgJf/faYdBH7QgQTVmNB47X8J/DSR7qam/ckPzlCCNahAi7amFYKaD6JBQfo20NLnHQi4hekS7h3hyBwKwjDDnXe/P/KxI0kBqXutl6busaEiYc44OQ3uHP5XXGPU8kjIHC8Fg8EqPGr9rhCSekGiEEjhf960LHfYXoP7YGc5kvq+E1+OEPQHjWBL4FAF9sfj1pWXJjBbU4M6dZZVgemdm4juM0fOPay1QTkYucQWY7HBqBktUGHfnG86ryHAUYKHf3gudDmPYRFUjmNPsdxx9ZI4HldE+9ZyEpV5JKrUmyha4pq5PrHqoARSXKOrWIM2iDywuFOd35zhlacOlFA75rKvn3iOQ+j+9rAIl1eClY2kZUfBL3z4FLDnBq839COxCOpnEgXHLFAqrLGQoQGjyRNqtJsiY0rxpY1rRTDi6+KPg7u4OsGp6vACddbOd/IAiJzBol0JPbtb8uaQeTdyxaVWHYPZBPB2hx/ZgiqCkwi1edb6KXJ0WPi2gMbZDOn5vHgOZL4Zg8hp+kHEK5UjVTl8YUUfAq2Hv3GskvFyaeE
 mBUvMOql
 XNpq6muv0VUP32tvERCkGlcQ9S/t8Pc7xwHBgpIdH55DzmTSq530UThF3t2srjSgbsbVa5G/qYBdU+lUXIEzL5qHoYOu7PGaeLSQes1IdN+lvw/A9DZ+RN4378umy16yDT5tRc0lUAqp/1tgWLxpJrNsilEcgqf2eMult0/HJzn/8mb3XUxwrV2xkjPTehm0imeDaQNanEamVwy/yoaIK8qEz4jjyGZzxHC2N5Qxfl+rxHLtEeXzUkupDpWmuKum31oSeacpe7tdwfXjUwdunx/gccw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 07:18:43PM +0800, Yuan-Hao Hsu wrote:
> On Sat, 19 Sep 2026 12:08:35 +0200, David Hildenbrand (Arm) wrote:
> > Please don't send out a new version
> >
> > * Unless a maintainer asked you to
> > * At least one week passed
>
> Understood, sorry about that.  I'll sit tight and wait for the review
> of this version.

Also, and I am struggling to believe I'm having to say this, don't
completely ignore feedback you've already received which told you about
multiple process fails?

https://lore.kernel.org/all/aq1CjdaPUg_Fos0t@gremlin/

--
Cheers, Lorenzo

