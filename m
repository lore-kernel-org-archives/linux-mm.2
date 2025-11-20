Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED0FCCFA441
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 20:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1AB6B0032; Thu, 20 Nov 2025 15:23:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A4B6B0062; Thu, 20 Nov 2025 15:23:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF91A6B0088; Thu, 20 Nov 2025 15:23:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D803D6B0032
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:23:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E31157D50
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:23:57 +0000 (UTC)
X-FDA: 84132111714.29.1DA5564
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D4267C001A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:23:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r9UnyXZI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763670235; a=rsa-sha256;
	cv=none;
	b=W6lIJUBM15QW+cdLXdVuI9azWdUVym4/BS4l/aOC5azOdWsYG1pKV1EOFl/77oI5EhoOxt
	wCpjw9hl5QovfUNoe/WKzS8zYJyTs+nWGQMyoDD2t3eh4z6esVAUoLD6h2hwjNfxpg8dXf
	vaxOwMP3PJUV3zW4a+UUvWmYdrQRtXE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r9UnyXZI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763670235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xT58wTbsK0GO5M6BVHaI3YDjWCCUhIyL5uwYgAHfxcI=;
	b=6VGz+YHrbc37roB+Iol68SiromfxP+QDPCic7itt5F1vK7cUnoKdo/2usUOEeZ4zE0mBIY
	zozmypLLJ7rAcgIgbIUbTEZdY7ahKv4V6wJybGyGzzfq3/Cn0gqM5AToBlTFeG+ayTjTlE
	wBcIVI9ZG1qOZJ1619QS+8Pqn++W0M8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35F8C60017;
	Thu, 20 Nov 2025 20:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A2EC4CEF1;
	Thu, 20 Nov 2025 20:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763670234;
	bh=a2FEA625ANzLpjWkhlLtr1SxRvZigA90QEKhvulL0yQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r9UnyXZIV7L8ZEOOeJT1nl62EE6F8j9PcBYhYDgjuXdqLWdOasVD1Vd2xaxL5PqfE
	 cHv1LnDQ9uXSc7KHeS91rdLs1uhyk0KakkBPQKfX1uspq/dM0doSGkbkcJxkqogn+b
	 PoEcIOSBZeHC8NGZAaCohSy30TRBPO6BLUrqCI+UnSI8GGfhz/c5NmV3iq3pYPDItR
	 F9FFuDHirpkbyfWCeUHIUy/iO5DbQvU6hFMlZQTQKemyHm76gGYOhO83Ek8lg7vWmH
	 JVxDDl6VYryFXKGDdGPRB7+r4Lue0oZ8GpEjDBZjtpZh0t2rHd0q+bIBNP+kvf53ii
	 V+6mOW30QW9kA==
Message-ID: <5c1630ac-d304-4854-9ba6-5c9cc1f78be5@kernel.org>
Date: Thu, 20 Nov 2025 21:23:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] fs/writeback: skip inodes with potential writeback
 hang in wait_sb_inodes()
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, shakeel.butt@linux.dev,
 athul.krishna.kr@protonmail.com, miklos@szeredi.hu, stable@vger.kernel.org
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
 <20251120184211.2379439-3-joannelkoong@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251120184211.2379439-3-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D4267C001A
X-Stat-Signature: 56s5k9pixaoitbbntxiwpr6oruwfeacq
X-Rspam-User: 
X-HE-Tag: 1763670235-705554
X-HE-Meta: U2FsdGVkX18tJdIO8Mi1Tbhj6WxCLvcz6RGK3sFXcoGMf44VCKVVAPQYa3AE9mMQiRVbkThm//Nwc5x+S91XDQZ8vms46F+pErgsy3C2Jf3IJgfGziSs8Q/IzpCPsnCWhPRwZrA0TYXkQCFwVkraTomQBwVVsvfi2kP0kxIIceHcamLPxzUDQI9p1JWGGdA+T2WmcvMBmI0Cl3uxXFmW+AqUT1Sn5H4C+t2qKvgFcbwuqqxbRipUy4qD+9MHx4+sHmNQ+wkMcYBjc2s5l31hUCoyq2ugOMJzOWmjgDwC0EBZPhHb7e6A2WsQ54Tg7yY0Qbe4YKJRpBgzwrMrtWRqp1N/XseWUVgeRmxXzWQYEI55xUBS8m6f5EgKZXMvqTWcTjkKeeOS18wz2Ume4VwaBxvJ6aEx5lqxuuw8wNiC639xlcXg7yvkOEWxkgqRXw1w7ZdzxUbv+rsEDNhj1D/6bQB0EH9qF91bynf51VhfVgQaPIZ+WZmlS++lb9HSuO8+CRrLAxO+ycZFvmHY6A/qZRS9+26nwaZndGRDPetgrfPNg7gYAvvUD28/+jE5uFT85OMxv+4k90TkePQL3jXoWMJ1Dt4sLwMqYIdrlafDbZdIOZ07Suvkeb4qiKTmo5o6VVXUp7Y25wY1M4ed6tZbQiO4beJBn+gW20N6m6UDo7jpPhVEEG5taKnrwSZKhxYNk1E91wZaycyiE0gt66QfARQERYLsWTzEAfvHWoLMPYYD7Iq15D0N7xjOlpZieufO4SUIQHGhvziA9X3+xidxSbAbSPHKAcEqdUaJquognjy6iUT8WyQ6GlvvIJZmrI4SRLAK2HTi62r8k0MhBouxpQXBYPxgi7JtDlHBaGFLaK1LNANaOJQZ1W1fVVhNHLrvApS+ieoKvfFgzTI9zWcEKWCa363dyQsV3R0zZXdqY9uar0/I4TB4zFlTIYMVULfyUm4ftvrclW0mUg4lvjq
 UlTpHQLH
 te4FbfnLRYHxy9EY7ojZAu7Q9lHNSyELcuTxtBMe83kv4BaMxW4mMy0mRQnEmkM3bsrxAoHUvaeaeb9q8+djuRMuXMCwKuulG/AF6DyQ31/aKwXHuv/3Q/7iv2NCwDHxIWwt1uOVeJ1S9kVqUooB+SBt8f4mor/Zs3NMO0bg5n1bZjWCsnxeHbvz7MgKxQZwaqu/AnL/XzsO9vJOQJxAWm/PCDHuMgZIg48x5cKY000biV+guAsBJtu9cFXI9LNEIFZxD7TQME1KyiKdNe4R2TV45qccG0ClxLKQppL8Whr1nE+zIhs/+by3D8YQmByKcYgGSk3V8x9G1UlQInhslsQGDYEmwVEvtgGRfIGu2qXIVIeDWJHhyuDeOKT5nr8YpF5BX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 19:42, Joanne Koong wrote:
> During superblock writeback waiting, skip inodes where writeback may
> take an indefinite amount of time or hang, as denoted by the
> AS_WRITEBACK_MAY_HANG mapping flag.
> 
> Currently, fuse is the only filesystem with this flag set. For a
> properly functioning fuse server, writeback requests are completed and
> there is no issue. However, if there is a bug in the fuse server and it
> hangs on writeback, then without this change, wait_sb_inodes() will wait
> forever.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal rb tree")
> Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
> ---
>   fs/fs-writeback.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 2b35e80037fe..eb246e9fbf3d 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2733,6 +2733,9 @@ static void wait_sb_inodes(struct super_block *sb)
>   		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
>   			continue;
>   
> +		if (mapping_writeback_may_hang(mapping))
> +			continue;

I think I raised it in the past, but simply because it could happen, why 
would we unconditionally want to do that for all fuse mounts? That just 
seems wrong :(

To phrase it in a different way, if any writeback could theoretically 
hang, why are we even waiting on writeback in the first place?

-- 
Cheers

David

