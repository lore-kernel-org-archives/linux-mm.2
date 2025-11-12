Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40F6DCD342E
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 17:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A408E0003; Wed, 12 Nov 2025 12:34:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1DA28E0002; Wed, 12 Nov 2025 12:34:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5A3D8E0003; Wed, 12 Nov 2025 12:34:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D17278E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:34:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CFDB4CC9C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:34:10 +0000 (UTC)
X-FDA: 84102653460.17.814C9C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E319D14001A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:34:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OarfSWcR;
	spf=pass (imf26.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762968848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVMTQfpR+uFFZ5GpabznOb6UAqxNQnQFVZb+i18J2uc=;
	b=tXVJJmicOpTGZTR9bv+ppGYVWfWk1jLkMFKDkPBYbbs+F28rgZpmNcxxCSvWfywe0o0Q/I
	L4WmWckIi+Bzl017lPyp3qqIEFVtupMZaKfIAgXh8mw9MTaflGiddTlUri+IPHuW6VXUsR
	AGxyrslqLJxYrVzmxHEXeiZ1+IYOKoQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OarfSWcR;
	spf=pass (imf26.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762968848; a=rsa-sha256;
	cv=none;
	b=jF+MFJTm9sr0ni5mQ3LDX6NT2wkWdHBDRmUcD4VlAdQ3AipycDpRdc9jMOXkl0qN5hl4GK
	MXQRjfUWAgF+RhZWPXAN48KrZpPHxiaN03ihf87F3Bz/1s8VP2ag+n1nSToBMxZFbfb2la
	exlIV2ohYx0h76cHrrb+DFpv+2rhuG8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F2F99601AF;
	Wed, 12 Nov 2025 17:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F995C19422;
	Wed, 12 Nov 2025 17:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762968847;
	bh=DAaxYL3UC58u9iDEuPfd0uEzuupacsBaOg9rSiBKRIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OarfSWcRCwq5sz+dcXP956dwRMxiuNcRnWSeI7C0EQVfYgJf5Fj/YRh0v20y+vtXz
	 fsXvUpt7KE3VWaezHh2TDJfyjC+wIpVWBxXujUnMOYmD6P3QosvVnniDv2sM7m1dnC
	 SCiVaJc2yA2r0OS4nfti/n/ysGJHZXmeoCMhdS6a/BtgXR1c0WkisuOGu9hxLN1ym/
	 RCMqMYwZoQz8whTN0jR8vatp1oQqCcYClta0XeL6ofEQgB1xAn9Zfvdzy0jIIZcnFv
	 sqUpRtMzOIhJAHgEWUFFbr3/Y0g5VRBc/gB4AvbF5IOwsyyrV6FOdCFxYvjIotr6Am
	 LtXmUmPc74syw==
Date: Wed, 12 Nov 2025 17:34:05 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: mempool_alloc_bulk and various mempool improvements
Message-ID: <20251112173405.GA2935281@google.com>
References: <20251111135300.752962-1-hch@lst.de>
 <48e45106-f76a-421d-8f9c-645469076ad4@suse.cz>
 <20251112155011.GC7209@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112155011.GC7209@lst.de>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E319D14001A
X-Stat-Signature: xkghjez4tkrafq4r1d8o1wm3ktnxh8kf
X-Rspam-User: 
X-HE-Tag: 1762968848-155361
X-HE-Meta: U2FsdGVkX19INLZaj5r0CWLD5hYf0OlBD+/qb4PEJoTkd1q+ymHmPorVSkNwgqPtWZRymDi/PkBt7ZYWKRAwsuFF9fR099kJ8pcOzezybr7h+yAPxhgx2EaueJmVD9lxfOFEiGwg5i+hPNqNQzY9FSKk//tLl4wsuT44zM+FyOzUrDvp60jbZHJENSaBfB3I1muJidVgk57ufi3e6XFGy3hZXYQhXhRjQyr9CbzmbrHnkhQsu2a9kHI0DBgAwFOUgtFJHNmI8of/QaCqIejIHvVa3I1u3m7JyGLQg0qHf2VkrK3ey1fbAJpy7GhESRmCkoRpzQYwHHVIjiCSQV72jepMxQ6HghP6lQ6MQGFtP7Bzn4nb/9TGcPrqE03zcJVqkxlEDjaYEgLFDFNAuxY3xHsi4YEgLMat3yPneEFcyYtieA9ImQgo7gr/FkEkc/docRieEMw8aw5YlPmAw3u0fuwHZB07DwFB05LaMEBruYb3vWoPrmsj4J5aa/QMVy7bt7M0vo4CNs3cVPRPx41LQokBb/Zm06WzAk5XpGia9lkbB9t+3GH3C6LCDXiZqYQuE0NtMgzHgJNAM/qaAHwnfIah0xfOgyQvRw53SVws2/eQad0FdYSR/KVWRDVVkxl692WrKnGhTiREQPj6hZkJ3awot6UGGB6+7oYm1k1clKDHeBT4B5yMCiqcOo9UYX4xIV6dW5BkaXjLTQlIFfSoExaDvqTVcmZt0wFXqZWB0Dx+jhVOYlEIfW0LRD43xALQkqfF/Wc1itc8FrH2z2+EfAxUUlcs7X/idpRZkvHDdh7Dw1zYIg5YHQhQomlymq7fNlJ5R7laW/dy8SF956J+g3TKE7Yrsqv5q6fp8xBpfMWzPQe3s0vfaptbiJcKFTDHGSbPNWaCMzafzhaNwpQBhylzfv0WxS7imbGvkPA3tWpktqzW6YBV98GXnufiVwa6N6lCquJVJ9GpDA25BiQ
 H3qN88B8
 iM28VhNLFeLb+5ANst8G+cxkXgRRECJ9gGinpqXoO82Z15MnBe1AgBQczxCaTc7RW1z0IZ0kXBdRgdLwshHQjaGwgx0Y7avGyF+kgusmk8ftMQjw6A1t+P2pRou6j0WU+R63rVoBC7WoiaYn8zS20B+N1/BbaYtg6TLNp6zXwj1+VkY/n/9iXV+vHh7wW9mKPQ6U01jELenSOsv9h9olVNFxw0w5ag+SJmKNgSmfo/SQt7m/HK+dxcjx31MRVB1LGKtN88+OYIWQuV47kT4xZ1pyvNW67c5DsReHCGw9mdJhRn/ep7lznyIjcR8XdTlEbYEBR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 04:50:11PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 12, 2025 at 01:22:01PM +0100, Vlastimil Babka wrote:
> > On 11/11/25 14:52, Christoph Hellwig wrote:
> > > Hi all,
> > > 
> > > this series adds a bulk version of mempool_alloc that makes allocating
> > > multiple objects deadlock safe.
> > > 
> > > The initial users is the blk-crypto-fallback code:
> > > 
> > >   https://lore.kernel.org/linux-block/20251031093517.1603379-1-hch@lst.de/
> > > 
> > > with which v1 was posted, but I also have a few other users in mind.
> > 
> > How do we handle this then once it's settled?
> 
> Good question.  I think there is enough mm material now for a merge
> through an mm tree.  If we get it sorted out for this merge window just
> merging it through mm even when there is no user yet would be easiest as
> the blk-crypto work is probably not going to make this merge window with
> additional review from Eric and I'll most like have another user for the
> next merge window as well (block bounce buffering for !STABLE_WRITES
> dio).

That sounds good to me.  Sorry for the slow review on the
blk-crypto-fallback changes.  How about I also take the two fscrypt
cleanups "fscrypt: pass a real sector_t to
fscrypt_zeroout_range_inline_crypt" and "fscrypt: keep multiple bios in
flight in fscrypt_zeroout_range_inline_crypt" through the fscrypt tree
for 6.19 to get them out of the way?  They don't depend on anything
else.

- Eric

