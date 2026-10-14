Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA044CC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88476B008C; Wed, 14 Oct 2026 04:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12156B0092; Wed, 14 Oct 2026 04:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9A66B0095; Wed, 14 Oct 2026 04:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B47E6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:49:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04136A6571
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:49:34 +0000 (UTC)
X-FDA: 85320608310.07.DDCC763
Received: from mailrelay-egress5.pub.mailoutpod3-cph3.one.com (mailrelay-egress5.pub.mailoutpod3-cph3.one.com [46.30.211.244])
	by imf10.hostedemail.com (Postfix) with ESMTP id A0993C0005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:49:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=LkEOXQud;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=bIbav1bI
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791967773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7DJ/UGFLzwkNS66PIQWaKVeCgpvTQiAHc2IYYxMeEEk=;
	b=Ym779JAyq/kz70EwtWHiWszoE4s2yDn84a+729i2EGBy8KQ85jpu+B4zNN/acdLVmg+SGD
	EBOZGO1QWSGr2Mu8etKcLHE4Qm6CxW0LnP9020OEb29Fr88AgWlv5DEud1ch2jnV6/e9hj
	g0C336jMoKW8CLS9uHPeKOl6+3WeoNQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791967773;
	b=YS6K5X6SojzW6WThA3FsaQb1oA9/Jeq9vsqKerIg7/iEkAfatMNs39jjPbPLYVZVNlCO8t
	aL0EB81VDFd/ntljnPbH8eWCYG7qkT3egsJGHpKlO7gSPoI0/+HuTlcH/Us7OrIXpUXL25
	g0OtuFayhsp8yB61ZEIEp+aBBpxXbTc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=LkEOXQud;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=bIbav1bI;
	spf=none (imf10.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.211.244) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1791967769; x=1792572569;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=7DJ/UGFLzwkNS66PIQWaKVeCgpvTQiAHc2IYYxMeEEk=;
	b=LkEOXQudpR7YBHQNagzX86LoHvGegnuJ1Gu5RxUEDhlcBxxo2s/sZP012YrJf82F33vj+vLXZLALU
	 8sGt2U6V6Pgpx0gH1eypu34WzANOq/GTujeADsvXIdjkSl4iuWRRk4SZtX7oUvSKWUBNRE6CoELquI
	 NxqJAMJ78sQgBL98jTCjE2lxLHua9lY+31HlbmWYl8Hk0h+b8IyrON2ultRuJGX56Xv93E8wKcpqHQ
	 TsvAntC3wPRflAQdRRZY2DYttNCuRMGXLUGyYnunJnjHKB4sCMuRYbnIn/D11CI+TrlObmsWAZsYgL
	 XTipH9IhT7K5IoafI6soKSSeXvkpsBw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1791967769; x=1792572569;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=7DJ/UGFLzwkNS66PIQWaKVeCgpvTQiAHc2IYYxMeEEk=;
	b=bIbav1bI0PGlwbDa+he/557iLLxhcswMt8jNeVjOCL17i2zBnInehWQq1n9276Fvc+U0QQy6NMPf8
	 8bV1vlWCQ==
X-HalOne-ID: 29a8c86c-c7ac-11f1-9ee7-310a91e02fd3
Received: from localhost.localdomain (c213-102-77-204.bredband.tele2.se [213.102.77.204])
	by mailrelay6.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 29a8c86c-c7ac-11f1-9ee7-310a91e02fd3;
	Wed, 14 Oct 2026 08:49:29 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: Harry Yoo <harry@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	vitaly.vul@partner.samsung.com
Subject: Re: Re: [PATCH] mempool: optimize mempool resizing
Date: Wed, 14 Oct 2026 10:45:28 +0200
Message-Id: <20261014084528.1280968-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261013091408.1231786-1-vitaly.wool@konsulko.se>
References: <20261013091408.1231786-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A0993C0005
X-Stat-Signature: otjpuum6d3bieceng7cjwnjamxfuzuiy
X-HE-Tag: 1791967772-934281
X-HE-Meta: U2FsdGVkX19OBCaa5Hig3bB+UkfmTWuLsthys73WuYAOG3p67Zm6TDo+zXIdWrcUV/C57S+Jz2hUFlWQNmVkuDGOY5NPkgBftXJYzoQfaU+C8lrJDLTAKiS+XG1dj/H4krZM1nSJ2hqhyXXEsL2PDDJwfzQXdS18cQyl1NgAFV7Ah2LTLzWm5EmBHOSdzS8qj50xoxLxCOb4ZuMpkCCGP3C56qMQYsbdmSdpe0fB7O876sGYtpaFaA6we4xbHobrl1DH/3PO+HMFzBdIcGapgpGBZo8XgQqNCskcb4YFRyDjjoP54g7u4Hxpw1g0Ioe2JcMgr3BIDQZjZK2rB+HFQHojtAvoGPIvX69jnjI63ktENbWv+Xk8BQ/10wf9afc4d4SImhVxGaNPgO9X2flHmfAsJMMJDdbiCW7DNv3DuBz6eCkhHIIkZ9YRrXca24Qokso/Du8OYmGLjT/HPkXUT01k2sDoCS9Svc/elYmTqKSU9eHSptQanVC4PbteUDjTuSSq2ydzQxLuFLaQ4bKw7DSLlLQHRkRCwXzhSeKPsLVPp3Utjy/DUlw6uzXDLJ2DddJZ2CP+usp+fCrR1ni2BMlYiFrrqfTeQS8Zu2qq0lEow+cldqSo8xE69HbOMlScXmoc8GguI860cUUW3t9S5Gq37FyaNENGLguNRAzaL6nxz7WXT9Fi5qNZDB4jdoQXMcXPnaPgoduRU/UOeepUBzb15sbpPsC9fbnMbsCE9t5YAlKxwhdSQn3a5QkWi53HJWG/Cg3Q7/vt5Jc1WaaSWhssIfEnZh475b+wvi0jX1jKv78IEFESSRUtgMwxID7MFR1/1kiZJvXC1UcAc9/S0KyabBPxfkVtBR8fQv65RzsIqTqkmSkyXyPXYL81EswiZWV2zEy+usqzwIMgw/T3hPfMEY0SCCHnNhHjeY/vdw5fFabid2sT8HojCxVKPPp2yoGvoGtw27tHcnV858r
 FnacCAKB
 nuoapMux3p0jVN13XqNQ/J+kiK7ksFMUotMXBTk8xfcWn4qqM092ktYGgMwud/YW1PDTpnzYivLYHEpylnmHPcTnHgCPp20D/KsIfs7qWdNWyHsuyDzEpS3B/8Rm/dDLzi3DWEV+VZ5ZaLu2kxdV9l+iJLyPlahaxerXz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I think this has unresolved feedback from Christoph [1] and Damien [2],
> so adding them to Cc list.

> [1] https://lore.kernel.org/linux-mm/20260626042252.GA7997@lst.de
> [2] https://lore.kernel.org/linux-mm/9104ac5d-ed2b-409d-8220-512dd4581966@kernel.org

The first version of the patch was changing the API and the behavior, this one is a pure
optimization that is transparent to all the mempool API users. Therefore, the feedback
from [2] doesn't apply to this patch at all. [1] is answered below.

> On Tue, Oct 13, 2026 at 11:14:08AM +0200, Vitaly Wool wrote:
> > Resizing mempool to a bigger size currently requires a new allocation and
> > a data copy to a new larger elements array which doesn't go well with the
> > idea of having a fast and deadlock free memory allocations during exreme
> > load.
> 
> Please elaborate the problematic scenario more in detail.
> Have you obsesrved the problem in practice?

We are using mempool to store a large set of preallocated rather big buffers. In case
of memory pressure we'd call mempool_resize() (via shrinker callbacks) to reduce the
amount of memory occupied by that set, and when the situation stabilizes, we'd go back
to the original set again.

Imagine you have a mempool with 10000 elements, and you have to reduce it to 3000. Then
if you at some point want to go back to 10000, you'll end up reallocating the elements
array and copying 3000 pointers, which is in fact totally unnecessary becase the array
can still hold 10000 elements but the mempool implementation has no knowledge about it.

Setting mempool to the max from the start a) doesn't help here b) is exhaustive with
regard to the memory usage.

~Vitaly

