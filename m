Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6461606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mnTo4Dt+
Received: by kanga.kvack.org (Postfix)
	id E625A6B06C4; Thu, 19 Nov 2026 13:26:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E130C6B06CD; Thu, 19 Nov 2026 13:26:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D283A6B06D2; Thu, 19 Nov 2026 13:26:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B51AC6B06C4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:26:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C12541C4661
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:26:41 +0000 (UTC)
X-FDA: 85452699402.30.08D0B67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 28C5920017
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:26:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mnTo4Dt+;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795112800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJCBxP4ULd1aGaiXR7VGdkikuMjsvHQubcW980ipQrE=;
	b=M5mIqT8fKraiW4VMHvQZiM3u/8xcg8lInRe8RIZvEc5DKaNcB4NAKSWsGCtaEnbgYX6oMg
	wcCa49Fn4xWIdDxek92QCxIiMbZqW2pJoajje4hRAxojvSkZjuts3jkKX5nTuHYZq7P+JA
	GNHIZKQ6UlbKx/qlLYmXGcHgs0r1oYs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mnTo4Dt+;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795112800;
	b=UxJl5CpqoqkQT7U/PhPoQ+RV56SairY1NpOn5fq9uUEUkDZmg36qWpkZuvYTIAdpMREWj8
	MXJN9Hd1Hdo4SxgDyEmk4AX7d64qpcqORsAQJJk5ckFH8uWzp+ySlTiTwJ3ZKM01alFFnh
	zYFRCF4AuKofYPo14LmVDaB8tFz7c30=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E744E43481;
	Thu, 19 Nov 2026 18:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8664B1F000C4;
	Thu, 19 Nov 2026 18:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795112798;
	bh=oJCBxP4ULd1aGaiXR7VGdkikuMjsvHQubcW980ipQrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mnTo4Dt++NXNpWbpPzPaD4O3G3wXwUDtr6wR+HvlNFyJ+gkk7vYC6FNgnKDdc2V0r
	 4XzKiKpAf71jYEaug4VH0mhOB1zpzdTdB5FR+iYSspSPbi6pgJIwgwYvZWyPO494uw
	 sYny9LvZGH7XbhrXK69WQG3KhJypWITsc95UTByEeq17aAUdfplJWHBzBCfVPN3Jun
	 nmqOCWIcQx3TH11BW8asMkFs9q1cizBE6oZORji8VS0HPx7Ob6+w07c8L+5udp/X6k
	 Kt4ECsoKHOWMSdhLBHrw9JF/zvP4A5/tWrg7adh4NPgd9tzPrGEP2eWu0u1Bqb7fr5
	 NvbKytx4YtkZg==
Date: Thu, 19 Nov 2026 18:26:34 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ian Rogers <irogers@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, Elkin Cruz <elkin@google.com>
Subject: Re: [PATCH] mm/backing-dev: pass "%s" format string to
 device_create() in bdi_register_va()
Message-ID: <av8_U9OpmR7FtHzh@gremlin>
References: <20261119170517.1515872-1-irogers@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119170517.1515872-1-irogers@google.com>
X-Stat-Signature: eo5dosbt93p8nyjmeeirmpxc8amt35yy
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 28C5920017
X-HE-Tag: 1795112799-108011
X-HE-Meta: U2FsdGVkX19mhtvoojasrf3ZzxytvHtKGtql/7jHkJoOpNOtGCmDja6OS/ho/v2tYusDRkXbAp+Z7Ddm+DnHvemMsPEAPNu0a/aHHqgukwmkqfXsa7tBgfSffpuIM2VlQiPInUBpjuvwmpeqP2OZm3dCnelVmqGHvJvEYL1JHj15Mf2O8G1fL1wYzA+AI1vBy865WqvxxMywi9qDQvAvrLZPOa1sIuYe7GheOMZymGnf2Xp10oqZKisg5FMQxXoZy6Z+0pkjiSIn7Fb39ad0mfR1S82T25PdkGNKmoQzge/g43PcGYNroGR4kmfTKF+RLgxtRiiziDNfCt92yQfLwt9yXCjQW4vNadIqwGjiNMZbnnJdLLvEz/suV9qZjY1qVKkuIKo6WqptG/+ZMKazyxdDh5fXmDYZeQWXl8c03RuZ0i/suhU2nQ5evqYGJ4OTtywG+aGuU8/wL9H4B84FLAHh4hmWLZa7rdEYKbRe4DhyRWfEZs9EKTiJYd0O9uN/Qs33iisD4LTJjmPLWxoDHp91gETlWYO53yNk2Gm/Mdkled3pO3g51hQhSgF1fTPzt3bk0z1lJmxJR8bT+4+x0HSBbN6gz3/QETpruVfykko9dpdjBDr09hd4HdvRHHgFjBEVvnV0o6vvSLeEeAAuO2vG0lYWpW8dR3icrA4edR0J0/wPs/N6ILLAwkNr1COaxvLGmK7PVwVM2Zz2tObfRB1vsWwqPuSxnTlKKNCH+gAGCGAgS3WkbjEYLt2RH/eb+xiMgy/PXPBAmeajaF+vUcbGcrpgAUXPom/dfYnj9473qnGnNUDZ5QAxvU7HeCI/aWx6NLzct+ozt+jOfKYrHfvws7vqd+yU+3tTRb2cxqdOOYdFAmCGlfSi44XbcXO+WGrCstv4vvkiEKUq0lpuXCff3bIFEmgvdj9YqgwmRWx15+m8BTvWBNw+bCF7EyqXdIeddkSM9WanVnTmUuu
 n90GirYA
 dlVeRHtnndMeVRbhGkEmyn9TexuQJpoSQ4Y9brihKiTOs6iIQ6Qgs8ZPe05r/O5LX0BKsDgwwNaonYVXWcCxF/SbLeMfx7cI0+OvLSdWygqsXyLI8k8yP4aDgYOFIOVlZxZn8WvP034SXwU/RII+fAvc73TNv7SiY46arOse4aFnUDOISZ9KwEWJmdCyRvmWz9fWrXhKpnvSJH3wH0cLyKK49pBdnSMjPDnNf/NqS4KIetrLlh+n1ayqq6lzxnSl6kLCYSJxF/fBheqLkH+UeEnMAc7n+4DGrAxOWctcmb3uC+TpmQTGySjOo3Id7xgeQ0CJrT8FFfIRlBR9RAD2nJ26JzbL567aOA3Du
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 09:05:17AM -0800, Ian Rogers wrote:
> bdi_register_va() formats (fmt, args) into bdi->dev_name via vsnprintf()
> and then passes bdi->dev_name directly as the format string argument to
> device_create(), causing vsnprintf() to run a second time on the already
> formatted device name with no variadic arguments. If a caller formats an
> identifier containing '%', device_create() interprets it as format
> specifiers and reads arbitrary stack slots.
>
> Pass "%s", bdi->dev_name to device_create().
>
> Found via an x86_64 LLVM=1 (Clang 21.1.8) allyesconfig audit with
> -Wformat-security enabled; fix and changelog drafted with an AI coding
> assistant. Build-tested under LLVM=1 W=1 and -Wformat-security; not
> runtime-tested with '%' in backing-device names.
>
> Fixes: 6bd87eec23cb ("bdi: add a ->dev_name field to struct backing_dev_info")
> Signed-off-by: Ian Rogers <irogers@google.com>

Seems reasonable so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/backing-dev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index fad1495d3b20..58373d494d92 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -1097,7 +1097,8 @@ int bdi_register_va(struct backing_dev_info *bdi, const char *fmt, va_list args)
>  		return 0;
>
>  	vsnprintf(bdi->dev_name, sizeof(bdi->dev_name), fmt, args);
> -	dev = device_create(&bdi_class, NULL, MKDEV(0, 0), bdi, bdi->dev_name);
> +	dev = device_create(&bdi_class, NULL, MKDEV(0, 0), bdi, "%s",
> +			    bdi->dev_name);
>  	if (IS_ERR(dev))
>  		return PTR_ERR(dev);
>
> --
> 2.56.1.708.g77570a6a1d-goog
>

--
Cheers, Lorenzo

