Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1982DCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 01:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3A48E0007; Mon, 10 Nov 2025 20:56:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CB208E0002; Mon, 10 Nov 2025 20:56:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5078B8E0007; Mon, 10 Nov 2025 20:56:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A92B8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:56:56 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0CA1D140352
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:56:56 +0000 (UTC)
X-FDA: 84096662832.17.B995138
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 86BB6C0009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:56:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MxmfBm0N;
	spf=pass (imf10.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762826214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mm9Q7BxKtUFuWaZiJWMnqlQBJBda2jFcNxCvdGMES74=;
	b=yIErck9LFq6NjR8clnR/FbmoA3EzrjVnNfUxy/xRjnjzWdu50XOAYPWq9eDxS9WEHv6maQ
	xj501z/8/GWWqYbVY6+3uQOkuNXbtKatItlgBHx6LiouJGWyHkh7pJDN4iO6c6hA+ftXuL
	A+KdEUHwx1by8KbWOCeJydQz/7xJnvU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762826214; a=rsa-sha256;
	cv=none;
	b=rSBC2CaHwvv08BEHthtIUY1REwv78iUli5yzS1tqKMzjGwUU9zJl3OkaoeKdJaSH4xe2Yg
	+ZKv98TVG7aIqw9XXsiusI5cpojiRnKpxRnsFMhlm51n0PWWeIVLZI0wJKglLAszf5dhMw
	EdDuX1bVL1e039kOcVJfNXrCzH0a4wk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MxmfBm0N;
	spf=pass (imf10.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 277AA441C1;
	Tue, 11 Nov 2025 01:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144B3C4CEFB;
	Tue, 11 Nov 2025 01:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762826213;
	bh=VphCyfEENd4whxy5okj5882S0gPkjzD1ljXyJrlri9M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MxmfBm0Ny+/qaYrVoKT8KL7lULyFehtAg0TdX4XqyEc+9es2IDPHvHCx4C6uCwk0a
	 Ib7IYu4m1w1smWVD7J3nk8quEpNaGhXhbdRwzluMlPTdBcJfe6FXKa4vYOWL0phV2w
	 D+fC70IqzAMfxZU8P2OKQhqWVAc2awoSCKrnZY3Psmdo1u70CTxFWvQdpI4hwfD9uL
	 vkQj0YeeA6ljP8cUrT744/MzSdSaqx23yaHxXyxbtdbAoBE/Dikmys1367mPyLQPBo
	 Thrkszyvq6fFt0zf2+ImdIgb6iVrGUgaq9JxTpRebsfYHNHQY4FVQImA3SyXlaX1HD
	 N0skyOf3a0Hrw==
Date: Mon, 10 Nov 2025 17:56:50 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com,
 dtatulea@nvidia.com
Subject: Re: [RFC mm v5 1/2] page_pool: check nmdesc->pp to see its usage as
 page pool for net_iov not page-backed
Message-ID: <20251110175650.78902c74@kernel.org>
In-Reply-To: <20251111014052.GA51630@system.software.com>
References: <20251103075108.26437-1-byungchul@sk.com>
	<20251103075108.26437-2-byungchul@sk.com>
	<20251106173320.2f8e683a@kernel.org>
	<20251107015902.GA3021@system.software.com>
	<20251106180810.6b06f71a@kernel.org>
	<20251107044708.GA54407@system.software.com>
	<20251107174129.62a3f39c@kernel.org>
	<20251108022458.GA65163@system.software.com>
	<20251107183712.36228f2a@kernel.org>
	<20251110010926.GA70011@system.software.com>
	<20251111014052.GA51630@system.software.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 86BB6C0009
X-Stat-Signature: jon3b3qyowakx3bku6nj338ctgaym9i3
X-HE-Tag: 1762826214-712387
X-HE-Meta: U2FsdGVkX18W+jGiadWq6ymMgPlQqe6jwgoHqa/GRF+oWcDyYWuzItvHTp49OlnKNjrdaQY0QmufknzViPujKKHX0H3p0/B1ULi9biTT+DcGjC/JKoBMvt8bdgbxpTKAjd5xcVoKLYyV6Pbh8vYO15G9jJC/p7k6kG8hCbv6Km7oxwkx1WUVfkqWShTuZlT6KtOOJWgR3vAaENH66RbHZqZAKrUe4id6XxJ1NuVxfMHQ+o/YP1Iw5ZfRN79DR83QiHBA1fyU/9QOf3A3oLgv2HoVoUDN7DSim52v47VNdeegDiBuCJAMUlkjlCc/8diLwsDNWEj/InPsj1gezsmLfxKgJuuS9b43UlxRRl7GpmwgwmbUS7mdTQxJGwuvM+5osGcuZJGHeq7JcwC5CV7FL8l2ZLq3491PUEubkQhuSNRvECRrLG9NJIjCjBGlQgedvld47z3DtNTInreZC6sxLlS75A6U6/hZKRfGrgMNDqRgxMp/wJo1MN/kVovPbwUuxt/G545QJRAfQMiTcjNr6fBmIz3/t5+jgBm4X1ZDGeatYLZpnnnUCnxXork8v4pjBJOrcLmOk1/eNbqKkHpA4PXO4R7JvPIIBpEmPoIWk0rjn3gpuPT4BSt5+GUhVZqaLuSvO1pmcQekZn3CrVR1Dba9JPX+ADYtpqC6XtK6hJOp3kgbXQUdk4SPks6ufuGiC2pW0QgVyO9yku9K+AW2L1ynNV06dhQRx+0ATUgTOLNLW2PdpDnHMKOtXLH+S7DAeKd3HKp+P3kSlWzuvyGPdbm+sT88Zacs8DrkNocAwL6eggiiOJMXDWp3HglEmTb74HwrdsbhKBr/80KJp2OX7/DRZvfN4On4Bsr29HCzh+hcfR2exgVvoFBqSiNvCA+z8KCO8YHPY5OQlCHvxjeYd6lbovUg3rDTn/aMPM09ox8KZPuARTDW1qCTyCpXfwVWgXb8dXMy0Tn9S+lDaov
 rJMH0ogK
 +n4GjzwyTSR0P8NEn90XiHLwWKwS1u1Kl2Wj6aFEfC1hoJ9ll6RsdTo7y3kzSQsVICywBVCo7iHGvFbbb/qqFWcCjcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Nov 2025 10:40:52 +0900 Byungchul Park wrote:
> > > I understand the end goal. I don't understand why patch 1 is a step
> > > in that direction, and you seem incapable of explaining it. So please
> > > either follow my suggestion on how to proceed with patch 2 without  
> > 
> > struct page and struct netmem_desc should keep difference information.
> > Even though they are sharing some fields at the moment, it should
> > eventually be decoupled, which I'm working on now.  
> 
> I'm removing the shared space between struct page and struct net_iov so
> as to make struct page look its own way to be shrinked and let struct
> net_iov be independent.
> 
> Introduing a new shared space for page type is non-sense.  Still not
> clear to you?

I've spent enough time reasoning with out and suggesting alternatives.
If you respin this please carry:

Nacked-by: Jakub Kicinski <kuba@kernel.org>

Until I say otherwise.

