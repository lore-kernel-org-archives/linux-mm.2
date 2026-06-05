Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 423CCCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABBE36B0092; Fri,  5 Jun 2026 14:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92986B0093; Fri,  5 Jun 2026 14:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0D46B0095; Fri,  5 Jun 2026 14:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DFF16B0092
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:09:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5924E1C11DE
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:09:30 +0000 (UTC)
X-FDA: 84846646500.21.3C1EBAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id BE4592000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:09:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwmqoBT+;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780682968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8okm4VUMmFJ4/uejS+xBY+U1Zy2pD+88GtZ8JFsDLIM=;
	b=Fpv8KvdFN5WdFOohhzCzwvn8pTSXXigfbGmElf512Mo1Bw1q1i72RnUMasdAiV4JaevQ9y
	0Z1UmRf4e8BYmw4NSmJe9UkdnPR66E/d/MgjKvBU7QAvm8icyrt1OUCl+WuXzg9T1rfvxe
	XwwFcAE7xOEnd6UVjhwZELrEaXxX8U4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780682968;
	b=o9pO8Fg/d/dUwy7jYyHMYSBQZVK6DYw+VXfa3Br1/Xt3p/fXWtwjkEUTdGX4S6lXIs2gVv
	t9EvBblgBAh8kA8WGOPZgOvYNucsILEnw0UDwsUkd4Qhfmp4vw/zy6o7d03sf2vUEoClnd
	x/QBffRlw9coqC6ke0bPKsYN2HPJ5s8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwmqoBT+;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EF6B601E3;
	Fri,  5 Jun 2026 18:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EFB1F00893;
	Fri,  5 Jun 2026 18:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780682968;
	bh=8okm4VUMmFJ4/uejS+xBY+U1Zy2pD+88GtZ8JFsDLIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MwmqoBT+H6jm/37A2qDJ0pEvRL2HUAWJWBAOtUi8ZhWYcsigeKif7D+soGUArDr1C
	 cguRomnrcHgH8MS6NkWAdpaw4YL3J0DwUe+7N5eFgkGmrEZ/OYCT0l2tOWSThcJQiq
	 kKwQYZRbaXI0k91YV3ZTa0Dx2V/6Tf5Hu7br6LAK9pmupKtKa2/nLiQjHaCDrtBCMj
	 auFVPz1zVR5Csbvus1K029GUxFmfsvP01zQLtYkAonNOkyfOU+vG04tKBKTAU6cEqV
	 BlKWB2y0+WhmZrVriKbyvcwQtaoGlc/xQMaJ72gzFJzON58dyJ09yaTxRMGlvIOF0f
	 I3rhRblEHkIww==
Date: Fri, 5 Jun 2026 11:09:27 -0700
From: Kees Cook <kees@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>
Subject: Re: [PATCH 2/2] net: skb: isolate skb data area allocations into a
 separate bucket
Message-ID: <202606051109.C96C81E3C@keescook>
References: <20260602183122.747759-1-pfalcato@suse.de>
 <20260602183122.747759-3-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602183122.747759-3-pfalcato@suse.de>
X-Rspamd-Queue-Id: BE4592000D
X-Rspam-User: 
X-Stat-Signature: ek1dejkfznnd8798or5ych5ou6xnjrij
X-Rspamd-Server: rspam08
X-HE-Tag: 1780682968-749910
X-HE-Meta: U2FsdGVkX19vz51sGEMHkIWWFDsdEP84pzefPC1kAkU6A61bqJw5hmUUO5sFAm4LuqKmXYMObiBIpLP9x+lRKsynSiI3yWsFWIrxIHPGcjWPiYRhmS7IRGxSUqDgT0F4Zl4zi6ae41cTPQtwrKMv8Sf5MOsUUhqk5XB4U7s3jgoZE4elnzBxMdHTdfpTN6PDLhcB+GZCE1ZVXrCX8HOjBOSkTlJU2b0ICJlotvW1EknqaCwbpBvQbzIh3i7lamZIz0dcGAd3KGhgKdMyZ3pfpZO5JK/rJ0xBLdoz8jzYRq5YaSK0w0fwiOXYAWF9KjM9c1VhLtkCJVwh/Yt40CD/Lqe1TRqxCqECznLhdr8lTmdBf4iyW94oKUfgLmO5pdlnWnipR+zPNtqxkB33Jg7vEcC3qOTy2W39CXtH8QKxtEGyYRar99s0ofiUxY4/Iejf0zspdGI9Na1Nt9580/bPXyoSwGh/nkqK3+vSht9/9kbDxwy02fo4D7lLC4CDVW1cBM1xboOIyxJdUbxM2szD4lnxamtw1cXCWLh3c5olMcIh6QTFU2eHBLlPXLtxO813lw6mAg2xlxGkO2z7ieLP7CBpVLL0b+xe53O1ox3J1zBcw4t/y9fyBquXIAcKkGYEEX5TPSfsqzuwqwMhaVbj4xMO6pzIuRJCtRnpFciwQOkFAkypZIhHaS/xpiKO8BnVigJvTSMB4H20SApL5h58FESR/eo5TRkdCBEtOOVq9BcsoR/CX0Dj4lN2CmYl8QA4WxkqxWd+/xMJdZNl1p6CFYMAO/jxYdlnlw6AKdqKqSW38PEfCWwJH/+Pz8eTIFes8gYRmsGpYFFhSVsmVf8FD6xBE9/9BVXkfiXLrjOnHN76T3fbeBnPe92sKmNVPsoIKyNKhNcMow8tPgirWef+yoYGGiYtKS8FsRzMah/cTE6KGFIx0syx3sl73/KxZDtTmuon2c/w4Zk+Skqc4z+
 lY5uAo9A
 CSowJM+LPXtqrQQa8sk2Umh9nT/PCN4aSzNhsqkLbYcjwSRIkwfj0JPSNDgkh7FRN6aRoXkrAQkepHW0vw6y0sTXX1vGSySV4f2ywyMXppYSxH06R6yKhu9XB26zBQelokSGBphaHSJrEbw+Rw8sAglKufL2VxRU66BDv79ilQ5bclAzlJwaL7pNYn/HMTtAmCCowbdRQmKb9/MD1eKgFOt+UDxOndtteGEZGJRnjx3Xby6keKQVzTJL4k/MXDNb62e3iAbzvsaIxpYQHmM+hhmvWf2PO5pqEbJz33YEmX4lJHOZ5tqrYmzOyap7QHFDammB6IDnxAn1owsWGATCrGcuTyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 07:31:22PM +0100, Pedro Falcato wrote:
> SKB data area allocations (as done from alloc_skb()) use kmalloc().
> These allocations can be variably sized and their contents can be more
> or less controlled from userspace, which makes them useful for attackers
> that want to overwrite a use-after-free'd object from the same kmalloc slab
> (which often just requires the sizes to roughly match into the same kmalloc
> bucket). [0] is an easy example of an exploit that uses netlink skb
> allocation to target another similarly-sized accidentally freed object.
> 
> While other mitigations like CONFIG_RANDOM_KMALLOC_CACHES exist, these are
> probabilistic. Use the existing kmem buckets API to further isolate these
> allocations in a guaranteed fashion, when CONFIG_SLAB_BUCKETS=y.
> 
> Link: https://github.com/google/security-research/blob/master/pocs/linux/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Great! This is exactly what the bucket API was made for. :)

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook

