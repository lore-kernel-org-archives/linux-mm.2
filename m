Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B654CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00268E0066; Mon, 11 Aug 2025 13:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D7AF8E0060; Mon, 11 Aug 2025 13:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EE348E0066; Mon, 11 Aug 2025 13:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5228E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:06:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A26C140293
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:06:22 +0000 (UTC)
X-FDA: 83765105004.25.BA7BB76
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf13.hostedemail.com (Postfix) with ESMTP id 41ABA2000D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:06:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=ff+XfBR9;
	spf=pass (imf13.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754931980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coIVAIr3cdiEGjXkXF8udEyXocm5M/hf9T95NILisnY=;
	b=S2CKYT6TfmCmu+IgazxXsFSGXphXkBkjdFbDW73MT8JkLDs8mlqRoNluPHgAcyBg4pwVrZ
	HFi3WZPZjZ5xXsd6Z+dzeTro5A/HYTwEOdSFRxI/BmlrzZvHZfag9DBmuB20mED/208b+0
	aHb2wQrTpBtjEMnuDndHgVTm7raNPFc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=ff+XfBR9;
	spf=pass (imf13.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754931980; a=rsa-sha256;
	cv=none;
	b=vLCb3b3S3Kwc2s1IE2umERNSchfveY1TC2xN4bPflFdn7ZbQl1betP3JiqUlwjswb47OL+
	lLwkcxwIWHTS9HdxMaJUkb0BOXhl3R1dsxed21nbeyWdLK/J45K8Fvb219+RQckV6MAwkz
	rpkLx1Vy7JeKMS1FcGHIEADkiE/XzS8=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 576B540AD9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1754931978; bh=coIVAIr3cdiEGjXkXF8udEyXocm5M/hf9T95NILisnY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ff+XfBR91ViWXUGVU7z7twKqHspUhMwcc6GbPZIOzzgpcvFwgNPx1jpQuYtzsX8zr
	 tohN0D/IYt/n10zZFKoTcI7E8nIr3nMT/pbqmTlRulRQkMeVXRiK/PNcVlb8pS3WIF
	 i/0cN8BSQC/xBJz41I9z0Wc8l+ZrKAoBSMg2yIFQcIv8LwQWQfpf5VpWPFaf1Opt16
	 9hPFQdIXASXwC6XNzuST4lCJSlGXUsK944oP1bYfMN3g3/lW9qdAObrAPQSkd2Y3Mk
	 MXTQtr5xRWewKvYSom5zfFQKEXzJnbHQoMaOZKpX62A5unpW5SbWufEv1+MM7NuJiX
	 A8whkUIRDycOg==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 576B540AD9;
	Mon, 11 Aug 2025 17:06:18 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Kim Tae Hyun <kimth0312@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kim Tae Hyun
 <kimth0312@gmail.com>
Subject: Re: [PATCH] [PATCH] docs: update physical memory documentation by
 adding N_GENERIC_INITIATOR to enum node_states
In-Reply-To: <20250802125801.10068-1-kimth0312@gmail.com>
References: <20250802125801.10068-1-kimth0312@gmail.com>
Date: Mon, 11 Aug 2025 11:06:17 -0600
Message-ID: <87cy91eqk6.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 41ABA2000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 556esbs55adwm5zwnkoe5ujida6wq8rp
X-HE-Tag: 1754931980-288215
X-HE-Meta: U2FsdGVkX1+zHhW4ailDL0Ar7+HJaGVfG+29dTa9eedEOYp7rdqlAnl3yYD0iFkk2Z2Je039dfwaZD/cs/rj4PtuyHJpSVGkWYawNSqOsHMeGg/riCVd4ouiVL7DZnO3xuFGKgi5RsWTWXt4r6SPTM5cLTsvfjBMAgKiDEwUTRtlOc1WZjrNF07lxPZ0VfAI8UAttgu7FUbaecSd/pbMIpGrqOKi0tO9ewefzALVGuBX/WOCDkEoOqWszDCPH3yhYTu0f7GrlryYnZC4p0fLb32ivlC4L9x1Rqtvzk9UZJArMbL11MK97ZAePK1u0fGIsq5UJ66p3stcGPQnNP3KaQE7d2n211udBoh0kv6JKZf6vUmE+YgTFXA/NFxtSTsCrKvN3zRATT/iaFB8np50SwWsc8j82UVuDZ8D6+4YWh/FzfbyEdZIq7s5GhXsfJEZEABfQkdfSIcLpHA6GFHRL8XSBJ7j/YGGhDwrbS84xan4tp+dBL1fFyKkTamhLj1e0MTJfI6tI1OxjdV/6st0Uc4ntRv9eQ6kj1RzRqlnfKxaYgMzTXJiuSkODb8QKhSeL4zOpIr8osXlwCskBovc1b8C9Y0ZHu2LB2zBIMK5fB2VnC4RzGonaSX3oz0v7PshiOmUXpq8g0zFHgxaU2bAam9hakjHBfpdNTLp1xveaoevFGeGr3tyhvpXrGRsnhJfWs0U+NQj4XfWxyIiTPAqNNFqW5R4m/nhzAD+IZaC3LBX8i2CLkDQz43Vy07m7aCF1mN2YNxasBmySJRk1sE7uYs+umHs1bQTGW2oSodDpYwKnr7BbO3Foq9YSKwN6f1h/GT5scDDMH5rJ9zWnf6ZHD47FSTPJzVSwcMnd07L9dpqa9t1OQuq6v7HTE+k/uss+11RxtUF0fbELlJ215TEPOiTWeZrfERzyZod/LfbK2UNSESbMVZ90huf7Ov07DHRpXi5b7ZGuAXFB6CtBiH
 9crJsZCm
 KBtqwJUQeCRd/8oh2/IdHxa5v23SxxZ91cHQVVUaj6Wmph9kxpmeRR+uDdmcVxvAnlfi3pvrrTfm9Ec36h+xzvAfgQni9Jiy1UUjTsItKs3ecB5QdPG0Tah1I2BrRj9mEO1+j43i9kIkSSBf8Ca13kITrjaDWT2tbKnzdv9hgZi3zE8+JAMFu2kekslKLxt8rxle5srxPNfYc5SenCndtOs7Q9NDqiDKiFVLNFc+x6tgu6WM/qsPa3w9apHylJqGsO7r9mIiGduA7ywbRieRn98P7S+Rw/eKzuZrwTrljP/FUt5J0VnUn2awFzbQ+dTOPkuPO63yhfgqxImoGGF/JY0En2micGK0dxq84xH5922ADoC4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kim Tae Hyun <kimth0312@gmail.com> writes:

> While reading physical_memory.rst, I noticed that N_GENERIC_INITIATOR has not been update
> from the node_states list, even though it's already added in commit 894c26a1c274b8eafbb4b1dad67e70e51a106061.
>
> Signed-off-by: Kim Tae Hyun <kimth0312@gmail.com>
> ---
>  Documentation/mm/physical_memory.rst | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> index 9af11b5bd145..b76183545e5b 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -171,6 +171,8 @@ nodes with particular properties as defined by ``enum node_states``:
>    The node has memory(regular, high, movable)
>  ``N_CPU``
>    The node has one or more CPUs
> +``N_GENERIC_INITIATOR``
> +  The node has one or more Generic Initiators

Applied, thanks.

jon

