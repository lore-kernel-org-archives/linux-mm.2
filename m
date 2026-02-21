Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2080DC5DF66
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 01:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E454F6B0005; Fri, 20 Feb 2026 20:20:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC9056B0089; Fri, 20 Feb 2026 20:20:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4CD6B008A; Fri, 20 Feb 2026 20:20:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B61DC6B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 20:20:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5526F1A0317
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 01:20:02 +0000 (UTC)
X-FDA: 84466707444.11.2AF883F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9F015C0008
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 01:20:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n047RjaY;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771636800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qV3gnbtmSdFKBPx7PZwnoDg72oJvaUt7LiSrs9T9I+I=;
	b=Y6H1RF1bNpqMlMwlj00MPf5hbFlybEsmlio9eril/wn4lHuptHRq2JWylOQ6h090et56BL
	Ty6lrBuRKWj7aOiW27YiW8uRkMIaKCSaNWV9d2oaWIva690ybm7l/9sjzWkGMImn3QAoUD
	o7y6YkK+TsLbrd0fB5gznVl1/5Iep+g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n047RjaY;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771636800; a=rsa-sha256;
	cv=none;
	b=ZowlH97megWrU0oOQLlQ7gib2WoSZ1NDQD2w+VHVPBQVkGJ5onjDK2J+hbtG+W6kDSk0fq
	oZ+zofp1NcxnuJwfyg3GbPoREylsZBSo88hUcckFahOwIaKKczcSBvHjOqvwVtL7CP6+Ab
	uVtgrRj6/Dykurzy1kxEjEsn+x2ewZg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 82A2A44167;
	Sat, 21 Feb 2026 01:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32298C116C6;
	Sat, 21 Feb 2026 01:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771636799;
	bh=BjknLUB+QAyCIfp8x2Ftdxi214oGTgbcsdz/cOi9bis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n047RjaYztwiUoeGtWaDw9L25OgxKagV0rGn2Qyrj7gpvAV2VOpKGwkBn3z6J9/eR
	 DoyxBGxstjt33DGN/NhfkPdxvQ2P8ICmYYZ0cumqFaTAxZvA1N3E6XLgjL2ywjymcE
	 pCiFV7dxqsviI50rCTOn2lgq3Qdth3U4809Ts7dUjWZ2cMGHCzPPfFpyzpAyIp6j1W
	 6bfXyFrI1sSIFJsHzSdz+KS1e6wMK2l35D2mjz7A3Pb1vWHFP/urUgde7KUR0HipPi
	 bp4L1Sn6+cHiCLqSVodPlSvWGSSwOiH5SITXaN5DrxWFp2KtvV+zJ7mDfQZiyfovFl
	 tzu1Yc9J1G+dQ==
From: SeongJae Park <sj@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>,
	linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Date: Fri, 20 Feb 2026 17:19:51 -0800
Message-ID: <20260221011952.59323-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c9o491rdoh5yuwa145ssbhtoy7yfsw8n
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F015C0008
X-HE-Tag: 1771636800-5812
X-HE-Meta: U2FsdGVkX1+4OVnHHmhTz3uhq9ezexzeaUIPSDOjuYAyn0fP8/5uUoMxeq4B6G1y2OhOshgOKI2gZhtgz0iYHxny/r7pFdqeNHAtslrfzfe5fNdJQWBtD7pIhpo+iI9r5T0xJkKD7Yb1JFKwuChkYseo/+SAhDHzhVanb+CAS3eJdWCnzYC7vdSSvQsq+cRzuG1G8Y/9QvMQACTn7UI53693IZuYhkFjvJLW07yKdBtlbGMSkAP5p8KnhKV/nax4ayCp6sgzDUkITcqhd5d40ijCz7jb+SNyfOHwx9oDceGXh1LSfY7EbhwvnoAeys6PkQLVjtStGFVHsdFIYgqoCHN9LF07YRAMAeqIsenoNpfkTQxJaJ4srt+h+48ssqx8aHC0kJszW+GlpO7HdMZVrqUDs8TMFXueYbkDujuD2L8iYMVtuta4sMShDvI2PzGfAWAJMIg6o5oU5mfruOkKeqg4pew5qrbNNbYe/fI9UrmOvZxsD8OyA6VqLWGTKMlEnTzSaxeGzdAhFaUXvbPW23x6YEpCgFqJcRHNiJRvvzXASEds6qofic7zuax4GVj56FTUBrJ/7/0gdroqhbzXItOwEyOiZhMVr68Gj/ZJuSlFnTIW8Xw9f6ImbCD0f6/X1zuoWMW2tM/LValrCuxWMdkH94Z5653/HR8kVXPSF+GiPuz2CnFSzh+t38bahc02qqffFFu87MRoxIAvVcQ7tIX2v4eEotXuurIcNDoEidO7yn8dm/fKiqUpuRglYhkiBXmuveP1DRSRV6k02YTcNV9AduFHfbMgpD1Tv++dCnJT6PuBI9U6wvoIjGoRQxhTWfjxF6SZNek/iji4yhv61dz2hZLzZzBifhwOqA4x3mJ6jyWBm7tnWFbl7pGBUWO+XErhGYZ5o5RbL2UiA/DnCdB8u3kUMDOexkIbhU1I8Ky9xzEfIJNUy1xyYb39uOHxLm6VuB1Q50wkqLvdSir
 W4sta/6+
 q4OqZ7Qz2Q2YqYZduNgEsWUiZGFgo2PUqr9lHxcju1ZmLnWQw8gTnyqWjAXOxaiaXWTqouTkdOht0k8zEZ7hx9vLGnfQg53chlu9DeyOhO+EwaLIGsd1PWH3pQhBsg9gZoEgby4MiIY+WiNImG122hdUmU5QwFcrq1Ie1UhpztBJ9261LJKMPushEm1nZFfFZF+lr4galS55d+2sSoeqr1h52ty5BL93Ylo3o9upgsl4ERuw3eGpzboUMtBMSFxD5qV7M67eU7rUhz+/UjPA9XQ66G3M7KvrrktUrVlW8QjIL0ILixgElHfJZTCGGtYd10BwGGqG7AjmJnfveGZBgSOQC/t8CWmhCDcxo2oEYB35bGRvIvNjm4X8ZApIpeM4hRbn+1GbXz4Ud0klP2w3FeSIzDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Feb 2026 17:33:30 +0100 (CET) Mikulas Patocka <mpatocka@redhat.com> wrote:

> The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> flags.
> 
> There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> let's add this flag to GFP_VMALLOC_SUPPORTED.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> Fixes: 07003531e03c ("mm/vmalloc: warn on invalid vmalloc gfp flags")
> Cc: stable@vger.kernel.org	# v6.19

Acked-by: SeongJae Park <sj@kernel.org>

> 
> ---
>  mm/vmalloc.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6/mm/vmalloc.c
> ===================================================================
> --- linux-2.6.orig/mm/vmalloc.c
> +++ linux-2.6/mm/vmalloc.c
> @@ -3928,6 +3928,7 @@ fail:
>   */
>  #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
>  				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
> +				__GFP_RETRY_MAYFAIL |\
>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
>  				GFP_USER | __GFP_NOLOCKDEP)

By the way, I think this list might better to be alphabetically sorted in
future.  Obviously just a trivial and random thought that never required for
this patch.


Thanks,
SJ

[...]

