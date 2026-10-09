Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F894CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 04:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76AD46B008A; Fri,  9 Oct 2026 00:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BAE6B008C; Fri,  9 Oct 2026 00:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6316B6B0092; Fri,  9 Oct 2026 00:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49A076B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 00:59:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A58A64023C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 04:59:08 +0000 (UTC)
X-FDA: 85301883576.15.F2FFA24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1CBCA1A0006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 04:59:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=al4jGM3O;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791521947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvwc8qpTFSOttTRxIpKEV19bQt6aeCiKQ4I6N4/P8tg=;
	b=3PjtSwk8iq9JxFmkbwfn6Q8cf8mjvoBrqfV02GmtJuwTFaFt29yKtyV3lp9FOUZNqbZ3li
	wn6tj6M5Mm4wJqNhBC92dMsMW/mtMGUP/13VdrYPuB+t/O4HzZYfSR6DGTB0iUpMncI+eA
	VpsDMmXAfmgsvcRz3qbmVE/BwCufTKY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791521947;
	b=YkFFBXKBlGd4qTGwVUxVnAPrRRiDHBRb7NCdXPZQpgUqKM6ST6Wt3bILI8aDhykAmOFxBq
	kgSNIe+R7v8H4oATe3SVQhCfd59bMlVifI9LUU/fDo7E3VGz6ld9Eax4LbdzxeYdPiGb/X
	21jya+2c9IdretdebHnXMzjrbHAm0MI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=al4jGM3O;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBA08602C3;
	Fri,  9 Oct 2026 04:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2F21F000FF;
	Fri,  9 Oct 2026 04:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791521945;
	bh=pvwc8qpTFSOttTRxIpKEV19bQt6aeCiKQ4I6N4/P8tg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=al4jGM3Oh4hjRtjtRtUYgeoaAK61OAO+AK7xuCcN8L2CrIA6aPsiUhhhmyF3xwlIJ
	 kwaOJ3FYtPXf/yJ+R0AAEW9ub4q//U4QKCU/0W/7i25Sorse9nPOVbQOMhP3S5W2XJ
	 MdKWS2V2M1N8NMZbKWmlbPn4omNdEebTR2UoGge1v+N5tqEU9MKfkegXdFgizHUS4y
	 CS6Y7X3b885Bw5ZSMZRBVZc3GW+AjVO21xby+8FaKMpQ2C4UgRWjTecZONszFBeisF
	 CxIJnDakcFHGa39xXOEj42lJodQJkLOI92x8+V9Cp6XKZnt74B9vXqS7uGytyDGKtT
	 s2irS2skeU8tg==
Date: Thu, 8 Oct 2026 21:59:05 -0700
From: Kees Cook <kees@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Mina Almasry <almasrymina@google.com>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, netdev@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/7] net: skb: isolate skb data area
 allocations into a separate bucket
Message-ID: <202610082155.E697E600@keescook>
References: <20261002231120.late.500-kees@kernel.org>
 <20261008184020.666ef78c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008184020.666ef78c@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1CBCA1A0006
X-Stat-Signature: quhk7ztr8gkjmm8xtn6u4wkz3i9as7ic
X-HE-Tag: 1791521946-993962
X-HE-Meta: U2FsdGVkX186SdubeM6+gfuz7f1YmceoYSHYxDuAUtEJ+BZiehaBblizxVPsnDCoW4m8RLjXZTXpoUJ9LIh94pdIFYU1lWW1Q+w2L+clWzYAItdegztJvdSE2j1ezMTE9F8N0pJMOZUvQFdRZ9YuhdEXiLBKCABAmG9wUMg/8gkC4IzF4aXSNhS1ZhYu2fSfXGFODaPWRo3b2fsE54yyi0FGzG6pOMbgtBZ8cbLKRGKstZFmSfsVnWXPapxSAQGQyCLM99o6z6EEVqI7ZcZcjbx4k0Wq29paEQ1ggfZXbdSwilHpJCRDytoJrtbdk2UMCbZlbWl32jfatWpn+Gvrrs6S+gM8FfPNB7fkIw4SNU9nvmOhaRYM+EsleWztMMDsu5m5cna6ePks0oWFFDnsSr0chLVS1/LKte+8tTujbgU+4RHYTPdySyHr2t+ZpYf9UaYnYuL0nqcDUi7K1KJrMchng2iTfYxZk0VI0WC+34RAXwUOY6XjFTzV04LrCCYLb//hT1itxbQbPowxC61/tLdtVXYZ+yz80QKYLFUbT+K3mttSLOQ0U9qPbsoitKWiLCp/TWdQrWbQ7wGVnjRQAxXD1Kn8/vQBFUvF7smTMpsEwC4b9Gp8ZveU5/ehIbPkH/6a0fQD1fqbS8oV087v1NfHaEfDkA4Ch9ce6u91eJpT0B/HXNmJt7Src404J+CD0/B6FOebG5OCHbM5jofUsjKep+M85a4Odl5OndcXfYGf3rluyOasz2PWP+eviJ5X2ITI46FUA/zvq9oN7VITP358vUaGFMAdsgj1paXr2W8gMBKxrPddrqMdviq/NJ0BS7IkRcjKrOQ27YZliSHPNRzxBoXqvXIVIvYaqYPGm8c3JLqHclqqAjFIm+4YRsNm2yXphsWavHrR0ITqkFtfe2mgIixhXsqnpUzoLhS1gRuyDUicvQQI5vO1wDxCSDYScrvBKaOLoXbpLlOWXjF
 favieAQ3
 fZO0BntI1rGAifoQV/g2ANHVtT+tsY8TnzNl0kZaPc7RqWqZaPUGZttCakr5VOSYWQuV09oEMhraBSeWOCnwjoFvZIPHz6Krrsla35DbxcOAfMXQXPdNbkztvAGlZmnr4NhZyy6KnixnoHFMyZDsgcy9IAIabfz2Q+ojHBJc32yx0p/AEAmOwA6uuGpUX5yRzkGBetxdwhl998GmzKV/RhgiUbjVPUAcs06i+3uw4N2GeqbwLBT+LytpMa5B9KZjP/C4g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 08, 2026 at 06:40:20PM -0700, Jakub Kicinski wrote:
> On Fri,  2 Oct 2026 16:11:20 -0700 Kees Cook wrote:
> > The bulk of this is mm/slab, but the final patch is netdev, which Paolo
> > acked in v4, so I'm hoping this whole series can go via slab?
> 
> SGTM, I wonder, tho, why you marked it as net-next in the subject.

My "send all the patches" automation saw a file touching net and put
the "net-next" in all the subjects. I'm struggling to figure out how to
redefine this logic to not fire with a series like this (it's very rare
that if I'm touching a file in net/ that it isn't going via netdev). The
best I can think of is to check if the cover letter is also being sent
"To:" a netdev maintainer?

-- 
Kees Cook

