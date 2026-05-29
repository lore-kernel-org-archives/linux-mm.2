Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C952ECD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 07:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01D276B0005; Fri, 29 May 2026 03:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7F76B0088; Fri, 29 May 2026 03:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7426B008A; Fri, 29 May 2026 03:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C86066B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:56:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BFB39BB33
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:56:54 +0000 (UTC)
X-FDA: 84819701148.16.FC2CA24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id CBEFD140003
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:56:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cJnfCa+/";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780041412; a=rsa-sha256;
	cv=none;
	b=mYX5zYAVR7/QT/GjGNMBk/mydiWKLqvqIDqxn6oH0E/oN2bjPjRttM9iN7uCGfWOKmUUlA
	QoJ+/v/XUtYdGpxnFWKtJVslFGqRB3SopRKQxc3psFwXdv85cDr/NFBQjbY4b2MbPvhD0r
	PUSKR9+lwzMstiziLQyVLo7nyiQKjoc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cJnfCa+/";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780041412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3MCAc8LoRfSuI0bxy1ZupvJQ9sT0RuY0x8nQ4Cpvb6E=;
	b=Qrvtpsc7OakI+Hw1atrzztUf4yDJj0WizdfdOguCauUgFsDoJMfgcXYhiuLUZIYZezRAU3
	EZIvRE+KhLY0n8csZJ+tRPL2eM56IxwzahIIKmZY8dW63GstxznEbgkbzCzXFG5DndRUfK
	g/d0cIXtXMu8LSa5/all6wT+Pmuzcsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D9E7442B38;
	Fri, 29 May 2026 07:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4996C1F00893;
	Fri, 29 May 2026 07:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780041411;
	bh=3MCAc8LoRfSuI0bxy1ZupvJQ9sT0RuY0x8nQ4Cpvb6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cJnfCa+/PPqcAgkpvqezLMR2js34rRk5O0su+0QMFVJyNCuOqk6uWWS8vcRhlA4CB
	 mQgXzdDCRjKIpqHA5EcBHCiLXNHe8GgvfJVcxMMwx+EC4KpkRH2kjpeog+A77ZaWqz
	 EhrpBpUwo5teWQe8D+rF0DJEKe1uFw3G0kAKGR4KPdZOCbjh43F/W0dp5yeps7IedX
	 JwYjlXPm3gDeQV227wPy87XybOVTt2/hdzmjQ0UbDDqaxRo4dv/5P6O9fw/rMl2dqC
	 cFpkhbBzWMAE5BLbJ3ZimbjY2p45QVM9zCw2juQdunu9khq793nphxcuofJ3VNQBKC
	 bNojwVvfyvZGA==
Date: Fri, 29 May 2026 08:56:45 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: xu.xin16@zte.com.cn, david@kernel.org, chengming.zhou@linux.dev, 
	hughd@google.com, wang.yaxin@zte.com.cn, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH v6 0/6] KSM: performance optimizations for rmap_walk_ksm
Message-ID: <ahlF281drhpwUHU1@lucifer>
References: <20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn>
 <20260522202824.fccba46554fb6223e63d685c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522202824.fccba46554fb6223e63d685c@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: CBEFD140003
X-Rspamd-Server: rspam03
X-Stat-Signature: tukmwam39ea9diazsu1ui3aurjzy6em4
X-HE-Tag: 1780041412-590612
X-HE-Meta: U2FsdGVkX198zCq0kwtJkhNw6/qqpftfShuZVHYl93vr3qkLoVOjdLNPuthKGUM1N26pXRu09WZzMXFw0zkrsxWGT7xnVWpGHozHg9qqkYgSRhWgfETeclwfkbXRuUKLobNIXkuR11cR4Q4EYN1yiHDCwvAmVqlzHAPxqcgZ74qbtgNbeGvwwT3lrt0c4Z4yCLeo1J86W8u+07VlBOlsVmI2HpPGhE7u1FtpL8LwyQwSnASymNX0dzoYnYupVtLM7dpXhkfijviNKs0qlV7VlTXT/11DILxZj0uBYyaXtNXAIn49wJ4kRmWaLpMLdZszEQ+CsxuNrrWLSA/igvRNCNbZT5arCTpPCplCnYTT60cwG0N5wDbXXZYEHbgnXjHc9CRd5x9ZjG5+Z/4pdusKCKX3h0Y66UHELtrlw+J0uh1bia21J/0Ojt6lllOz+mE6VPj02Gs/lEr89cyQr9bc6YchbqUWvfieflNfd6AGLPrL7ulw2kGdtfPOT2GFLKQE+tZt3FEvD2k/McJFFzM+BHdGtZHHodxKRkLR/NTBaW0z2czvrWBNlViMNaCzGwDy09cmjFRvKOTtm/2yNypc8EtGw4+NMzJF6RLOq7mcFnoFty/ojHI67sNoFOJXvotd6Vn/fFdigjdYSjt5NE88PIklOSL+Xv17Gmc6j9Es13nSIpxfjavj7mdF6UU0LD6FmxgMWQWsWyc5gFpq4jQlt+sP40KG939JafJ4Oj9SBu3NlZIhPPRRQDmGupZtwh+MrLm7Wnjyipr+HIsiN+DeyrB+fvtMpJwlAAPnVc4sWnLFqvmw01KrroOjstn1TeGDW4CgeVPBbm0mf8HR9N26V2F6gP1ina5aG3L/ewCBVW8vY8UDSsqu3f0wTxXv6GKK0ii9XYnUihFO+PDHCbzrtmfy2AM9LY0HIFNqlq8aBAC8oUEvGT3cPUKhGRTTnSGvz18kPzVY4UNsoavCO4r
 9om5VbeM
 C3lA4lVOGzcyWS+otQuTEVuEuhtKhIfJyb66SAFRPw+DYvOq7YLNuis2GhDCYGa5dQqfotDPd5Euv8jBRd8JPUUtMyOvNoh9fwLGteGljqH8fNesYhPf/CgSsEsUQSx7pV019rPf9RPY+xloXJEgFgEgLYBIFLwXXWaViC02uyOap5l7dimh4729TjB4QoSiM9H2tD4S09rgosnlhXKFrvOatIoDYpwf+u6z1xD2lFMao0lTXKmCOdIqktkrUaSTo6P4gC3B8V2XwNdjk0w0EBZBWL6N62iWXk8IIXA8281NpPNMRCX0yNO11BASk+nAycVrsDAUSQQKUgyN8VilOCTb0ud5bRRFwwUpc1ysIBI5RwpoNEv9IQsWJ9xDLmir+AaYQIPMHwkpOj3+uJWV3ARjnOiE9HoJtpvRA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:28:24PM -0700, Andrew Morton wrote:
> On Fri, 22 May 2026 10:52:34 +0800 (CST) <xu.xin16@zte.com.cn> wrote:
>
> > This series fixes a severe KSM reverse-mapping performance problem
> > that can freeze applications for hundreds of milliseconds under
> > memory pressure especially when a lot of unrelated VMAs sharing a
> > single anon_vma.
>
> Thanks.  I agree that this behaviour is quite obnoxious and getting it
> addressed is quite desirable.
>
> So I'd normally merge this in its present unreviewed state in order to
> push things along a bit, but the AI review gives me pause:
>
> 	https://sashiko.dev/#/patchset/20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn
>
> Can you please take a look, decide what (if any) changes are needed?

I also plan to look through this!

Cheers, Lorenzo

