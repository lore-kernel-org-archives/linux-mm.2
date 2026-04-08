Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D8051073CB6
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77EB06B008A; Wed,  8 Apr 2026 09:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756206B008C; Wed,  8 Apr 2026 09:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B9F6B0092; Wed,  8 Apr 2026 09:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 508996B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:19:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03F8A160122
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:19:14 +0000 (UTC)
X-FDA: 84635444670.19.9ACFA84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 47DE480017
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:19:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AIw83rrv;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775654353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YScNHcooiriFbdmeL4Tp3HJE7rLumavzpdq7GpP37Fw=;
	b=XH2D7GmJR7QSbtkcS4QKKzN0iuf6FN9RgCdXMCLpX8cNF9Xnw+6Kt8azMsDKY8vFs1PIv7
	NEAzaXhVP2i9euABQk2DAO5Nw0SkUJuX6udOrKg6CGcM7LimgykuKwmDcm/lhr7x5J53Mw
	l0+elxnvnMnMyj8V/kvArErdyafLABU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775654353; a=rsa-sha256;
	cv=none;
	b=qLYOt1thwU1OWYhD9EzWncjhzEqJLDzK47Y4OuaqFazz02FlXUTL1L4/NXS+Dc/QRNWot3
	RZVuWDCLp9UdG6m25yI0yiLBpk1bnuLbm7BXENjNM4XOISvofyud8HA24clsAmQ2TyP0Gy
	ndvHXpdGaiZDSMaeQqKNMPznWXACd7Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AIw83rrv;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B9B560133;
	Wed,  8 Apr 2026 13:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A586C2BCAF;
	Wed,  8 Apr 2026 13:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775654352;
	bh=SjygkR+OlZCMcyaDgh9wDXqALS+VJqqfmDQI26ILLvo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AIw83rrvDojvVU98Km7jgfMLQYlD4Up927bgO//SYFCBf2d4ITJVSDviqBB9vDYY9
	 svEuilKhHojgBQH+59FDI/vEUolOo/FvJJfsUtS7suKWEW69T0J7n74BdPO1IQLM5B
	 rz47UNzz/tv19EHFMOYb/IW6GU2Mh1mbq4St/5aAA4qssffScHO065VyIWeF/JAAiP
	 b4Wc22k4PjpnDFupQWOqOl73qUgeWaS+zDrhE7qndLRd6HgKegFvH5tWQUwTIJdGsz
	 76tAqhmucNKduRsTjx0wHQ2Jf58Nj6nAp8aRNqp15RQHu1ikJZ3tGU+kLO7vsjI4Qe
	 HuDVBKGsF0V0g==
Message-ID: <8e34b0a8-836f-44bb-a6b1-703f79c2ded3@kernel.org>
Date: Wed, 8 Apr 2026 15:19:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksm: add mremap selftests for ksm_rmap_walk
To: xu.xin16@zte.com.cn, hughd@google.com, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: michel@lespinasse.org, chengming.zhou@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260408211552000LDjkQX010NY5GI_er7Qb1@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260408211552000LDjkQX010NY5GI_er7Qb1@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: tc9ybrh4ny3o8bpkapi5ozgjjee65mup
X-Rspamd-Queue-Id: 47DE480017
X-Rspam-User: 
X-HE-Tag: 1775654353-366310
X-HE-Meta: U2FsdGVkX19WXbYvIC4mZ/NniYuLPBjDB282MDzv6Jl9Mw/IATeCVvlfpkQsZIXuo4pW58g7fTcHp6O6O+lGGliaJcW7Xscn3/hHwaL/yQwqUcGK6LFuAy5vK/zV6MDSIPmBHNbTC8hpEeNbhrJYdVDAWmk9gFTgcMHal3IwP5m7y5bYHzOSgY/4Moj+bGGZZwd0xasiHrD6s9pRPaL8Z97+wd5NN8YF2rT5Vf10BtqeWOc1r4pT+vwtKxGpyG5ez0/Aj/blJcxJb3+TR4ZL7An5sQwDgqXKQI8M8KGdNBuR0uUsGnAlXHhJKkVHAIQht8lstyARkbITg1NPGGLHKCXXaTIX02rdn0gLUZDd1q32+cT+6NxtnBYw6yfhZAIUN2v8gv3maKHo9m2QDkdEt7oN3NyJbx1woFZmOE8TN9j+d4J64qWfyp9jHGXYjo+st32VWg6lIBEgPPyBxCekyvoOEbBPm08ryaRBPtkqUPKfbHdaOCWWzbU/5hiXCKI2o0ARCRyW5LEtqGEegp3SuFvJw5abD61ZyGJz11s5ywtBxt9J7PF7PSR5L+I1kqt55USdMRO6dQ0DcewErCIhK/wU6CVwTeo9ltRRMTYJvpsyKeTcdENjCsEBNQdjynSeFs7ZP62EfjFmOwdiHxxScDi6vC++6OUa7LIWrHRxPH1PoecJd8z7J5TvL/2eixLh/+OfX7VdQhNqi1GkPX2xTHJ99tSPceDS4sAoMRxRneQLnrdWnH6CrQexePJSBv5epde2c83ug1ScWeS7xZc/zm5JGWXjmi8mw87AC7hH1u3bPwd4akQcIUKNxNBVDU6csCHAsmoLyJcMJ3ID62yxjnT4tClIGzOj/Flpx67e/KdXFwyrWEM343atwtIG9tqRstSSiXuXKe7q11cuamycnDNGV1U2FSXfO86fwc9WX3MEsvuAXVN9r8SDKvTs+M1+cLiGGpclLDr24nQRzVz
 qgk1eCKQ
 +Iz7Q+esdBc9H4I8Yxv42G6inFfO7wyLPWmsBIbQcWDu9l5dzPlStafZgvLwik2dV/0RIFBCqhoA7MmOe0L/g7UQI0m9n441eNU/BsxvUvLcilwXN28YW1wqgxtaxHXssA45JLiUTggH9q/qpAd8YT8s9caEqOs1lCDcW+GZoaMYVOEJHcRHku4wNOoG0D1NklL+bw+77AvTGmdfc7H0yDBf3NJKhffIM19J9Vlx5wAVTCroMT37fKLaKM8DSovEgQgKMfjhiSmJ2aROd0+Nri/0FAoDS5NbuzHeBiq9PmJtUxWmxqEe5WODxV23Pq/dTJ8kxMFNoZD/MTgJ+i3cv9TjfDrkmv7lKHXAs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> Oh, thanks to David and Hugh's reminder, I now understand the issue Hugh was pointing out, and I also
> see why my current test program incorrectly passes: before migrating the memory page, the
> mremap() operation has already turned a KSM page into an anonymous page, causing the code to
> take rmap_walk_anon instead of rmap_walk_ksm. Therefore, to reproduce the issue Hugh described,
> we only need to add a delay of wait_ksmd_scan_finish_two_truns before migration (after mremap) 
> 
> 	— simply wait for ksmd to merge the remapped page back into a KSM page.
> 
> such testing code can reproduce what Hugh points out and FAIL to migrate:
>
Cool, please update the test to take that into account, and please also
test with child processes involved (no mremap() in child, only mremap()
before merging in the host).

-- 
Cheers,

David

