Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72908C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5435F6B008A; Mon,  7 Sep 2026 12:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4936B0092; Mon,  7 Sep 2026 12:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40B2A6B0093; Mon,  7 Sep 2026 12:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 254436B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:35:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B3A1C401D9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:35:53 +0000 (UTC)
X-FDA: 85187517786.13.547503D
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf15.hostedemail.com (Postfix) with ESMTP id E3CADA0009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:35:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=MwlcOGV4;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf15.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788798952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DAoYuIcWZTaMIojt62cimuryvgo36WyvyhrXztzDc4Q=;
	b=AWEMsyKBncdQKJyQYPc1gg1F2cnMKzhRUn4DCmfNh2T23jK894av9iR2b7rADqALEVJvJN
	fe6qHeFlRSG/ZVX8rsVI45Orgnt8HlO6ld8IoDeOOx8jGLv3HOKuOLa61XY6HWvkys1xNV
	jwa5fXvPUlDNgJRRFhmj7i8mjD0Uzdc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=MwlcOGV4;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf15.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788798952;
	b=tCtXoo6z5txcFIr56BtXInP/4HJu3Okz8+eIU1wvZly1TuDpzIwD853ozKTKoAfAcgVSV6
	qAfjm6mj0KbjDN3Cff9WvYmn26CsIP05u9W3kTeLsgWxnf5+UzykbD/rLnMwGOPVMWVQNQ
	rU7Admn3sjQBVxHzedjVUijjMak0Lxo=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 0D642408FF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1788798950; bh=DAoYuIcWZTaMIojt62cimuryvgo36WyvyhrXztzDc4Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=MwlcOGV4qbKIoF2pj4SqaiVN0lsc7ZrL5SFjn+ezQ7MH/4DPJyq/ApUQzDjcVMMjx
	 6Ba2igW5oSDoKf50wtRX61Z4eKDZY07aok/ov8x1oxNISjgI40E6z0H0tcd/A05/xR
	 173kja13E97DE0OIJQQLw8DKQgnXK+ETt759lS4BDmIM25A7g5xcRHHH1xn3/IvseU
	 doCFu+lkc/1A7d0lqPk+tw1myYJh+wy97Tk4ByevjPGmTosRJ/d6Dp8t3FE+/DXXRy
	 FwjiLBfKxglVpmUsqLkLk1MNPgkc10u9GstLb0Np6QYH1px1R+dyFF8JhU83D0V9T5
	 MUSE9OKipTbmg==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 0D642408FF;
	Mon,  7 Sep 2026 16:35:49 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Karl Mehltretter <kmehltretter@gmail.com>, "Liam R. Howlett"
 <liam@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, Alice Ryhl
 <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, Shuah
 Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
 <vbabka@kernel.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: maple_tree: Replace removed bulk insertion API
In-Reply-To: <20260905015509.76265-1-kmehltretter@gmail.com>
References: <20260905015509.76265-1-kmehltretter@gmail.com>
Date: Mon, 07 Sep 2026 10:35:49 -0600
Message-ID: <8733vlqasa.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: zexanbqaf1yw3wtm3d9mj1seeohfwbeu
X-Rspamd-Queue-Id: E3CADA0009
X-HE-Tag: 1788798951-967689
X-HE-Meta: U2FsdGVkX1/ERbi6Sp6kWoPFz8OQKDnxk5D2ClvFrS2tCysUyT+aMmwnQkS/r6DxTxilxKAYB48VUPyyOYtH6CR5MmJNc3tntuNNfdyBidS0GrjJSniZNr9h/tQAlDrGwIKqTHhntPD9zGgjzXlkKKpqIoGapc3wWQAnhY80nUGIYHCHgyG3A49f5mL7hYY8o3uhJtxjueJWFuFmxbWjqw9tZ7SuEC7VPWABa7eRFrlIjKUKj+hZR4rCVP1g2wwmwcp+2sTKfmccp7aTMaiQnZ8LrbYnu/7ukdZpNfkDjy2HJXwN+x8hpuYKJLwM+i2ZlqE+Nmrx2WiLmzIsaibZ7K0AhXeTjDw5OFHZ6TQZ8s56sJLlKR1e8a+ad/P4BuTilQinkiGcZ3d9r53KHQ0QCy09cu8HMFa47hDcjnRDh+VNYy/bDTzTUkFkLoBrXoUzqrbTorgDxoXl7G7AzfYJUDxymkEWZdMpcg6/YhVl9SGqo33qlwJAlcMEa0Q6P3RFlnggR/qWzTfIwtlXjBOmrJAviQI60Qp36LQ3bIKsbwdCCXk73Wh0jNWJ4etSeqJLr9UAl5aiMmejIwbLbhySBDz4Ro5O722U7OOpHVyWJ90vtBcdwIpyc66n/Mld68tLRZLTRjvI0b/E5/5SMVci0h7kl+Zkro3xKF8P5PZcO75sTMjssxVaKoKnWZzrtL5IYsgkl9eM/wjoK7Z7BQMUXxdk4lb4e+X+6uuNQwzKbQZpIXF25OnTACzSqUjtOzNWfLcpYyU7SSZKzF9+Egb+uwSODq2eyun4Uq3jv+p7cM+tKbND2ue4M/nMZ/MboaUTSrUTMv0rD9vwPD6XhthZAzem9XCOVorwpaW19MQcfkyzXVFrdu2dLkhGwtCbYo88+unzEGKwGRtwjDS6aTAu0HqMH1tG96UnovJo2R+qtaWpClMBHmJzmnVYbIFg71sCEGzv1wGe6sDl575TpQZ
 Jc1fVXES
 +6ZKciCQ4OEPEkfDkAvar/8BeA2DsDqQ2xBm+qvdSKOQdkgabXqvZL+akS9+5k2B+9jazT6w/88w3v2pHMIfKgryZajlQt/ztD2HTo/N9sOG6GxUNgRHkCQrDvpMS09gU8uVwhEJf7gCE1KetWDh4AObiCpt8cLKpf7GhKGrtbI7RYIr7jqk/cGCCWdBcqzl2Shqp3SskanOZVUGmIV0fh2CfgAAWOlPdzfLhtbIKeGIap7gJUs06A6gM+vvXFo4KTXo23MpOjo3SmtMo6jr62+//vSgq85dOBui3GTrOm6JkZiGBv5tkDmTwVmpDSJHu4fVYTMixSzARPh1RpykWIHpV596GVWJs3IwVdxE8/j1N4ijC8Qmg1kEKfzhMpRQ0/8FvSpcPbS5EwTo2l/Z0u6oaTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Karl Mehltretter <kmehltretter@gmail.com> writes:

> Commit e3852a1213ff ("maple_tree: Drop bulk insert support") removed
> mas_expected_entries() but left the documentation describing it.
> Document the current preallocation interface instead.
>
> Fixes: e3852a1213ff ("maple_tree: Drop bulk insert support")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  Documentation/core-api/maple_tree.rst | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
> index 12bccfb6aac1..836342fb1eec 100644
> --- a/Documentation/core-api/maple_tree.rst
> +++ b/Documentation/core-api/maple_tree.rst
> @@ -214,11 +214,10 @@ Advanced Allocating Nodes
>  -------------------------
>  
>  Allocations are usually handled internally to the tree, however if allocations
> -need to occur before a write occurs then calling mas_expected_entries() will
> -allocate the worst-case number of needed nodes to insert the provided number of
> -ranges.  This also causes the tree to enter mass insertion mode.  Once
> -insertions are complete calling mas_destroy() on the maple state will free the
> -unused allocations.
> +need to occur before a write occurs then calling mas_preallocate() will
> +allocate the nodes needed to store the provided entry.  The entry is then
> +stored with mas_store_prealloc().  If the store is abandoned, calling
> +mas_destroy() on the maple state will free the unused allocations.

Applied, thanks.

jon

