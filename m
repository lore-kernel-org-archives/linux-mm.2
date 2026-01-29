Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E643D358CC
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 07:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE4F6B0088; Thu, 29 Jan 2026 02:28:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAC2E6B0089; Thu, 29 Jan 2026 02:28:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB83E6B008A; Thu, 29 Jan 2026 02:28:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C2806B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 02:28:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 431EC5BA57
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:28:37 +0000 (UTC)
X-FDA: 84384173874.29.F62E028
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1422518000D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:28:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769671715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C76xl4ySZka0nxwverHmwQ12oGPHYAIUVFec3WqlWxE=;
	b=ZX8iFDNxULVlSutGtlX+Or27+HCVO3W5ja9MVWThMREL3OOPLODX6gZRbY8xEeCkLk6e2n
	play4m81prcnB1cVaCp49Srzzp+1YS0Lo9XydofzH5LPPVlx5OKb2kpacMmZN/aKCgWC7b
	HC7S3W5Yw31ukPkhyZOHL6C3QWZulsk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769671715; a=rsa-sha256;
	cv=none;
	b=Q0keIdpFwdAB77QfaY/msiQB/gVUEnqtrc2Id1FPwsSI+I9vZelNSStJRILr2bG5rBierV
	YrwtLJd09wAwhjLMn0DFTWFb4oMK4r3u5sNFS9SgNL4dr4t46y82D8TJHH0/Y+sjlVcTet
	5cLOtM1V+utHS5tQVYjwfX01ZzMjF9o=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 29 Jan 2026 16:28:31 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 29 Jan 2026 16:28:31 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v2 06/12] mm, swap: implement helpers for reserving data
 in the swap table
Message-ID: <aXsMHy0rNreGmnLS@yjaykim-PowerEdge-T330>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
 <20260128-swap-table-p3-v2-6-fe0b67ef0215@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128-swap-table-p3-v2-6-fe0b67ef0215@tencent.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1422518000D
X-Stat-Signature: 8i5aernjdyxco7y9ypd67z5uhwm9zxc4
X-Rspam-User: 
X-HE-Tag: 1769671713-207802
X-HE-Meta: U2FsdGVkX1/vF5fIcTXF8W8JXeSZw3Mr3Jmajm7v45YOxKFJwU9GhC1VRoi5wFk/9QQQ/ESIW2Hp3J5Zwdsihj8uqfXJgyvKHCS6Tkz/iT/J+9V2OWi2H8caVvI3dRbvJG7Pslo1nnhXqkSocfjKZ6ga36IJlZSXL571Ly9Mhz6zmu7xpy9Hf+2PMql7ERoHYzIivHjKHKsQNtKpp5F9hPpdcvBhM6GcH/dCf7J6c2M1H70o11HXC42eh2zBWrKOmDk1sdz6MCW1Ev6lfVU4Tg2IjRZROGZkBFcnMjCVwASH0rDZ3ffK/6YsYGD1xHwjHZiQ+O0KTAraeUnGjKhA4JehXUB+4+ZEav0/I/qw4RYAzjVLWszfr5PIkJM4KjH/m33+yGDFfCkkuSGyJQ87unkl2RdktzZnwOYfl5fbpQUenh7BUmpXIPgf4PEMZ8NyhN6N8X1Fafr6l22Uj2+euLTMRe9t5uft+PpcFSLEeaGzkgK7SiZGIpiJ/IN2Kgy5KvKrFGR0xhmphaIdYgqx2lhyYfTY/KnR9op+7yD1U657ask7xhlqbauXBNHQ/9yl9ZzxS6esElNQ/BEz0D/+EEYm5v3y04VV4WTgXMPATmm4ep8wElmoZhREA5/wTabKtylGqcJiXkNgHue76KXB0PeG1GKY3QSBhToz6TwzoA22I6CM/Xxmya1CCRfBjYJ/Kj2ONs5BSFNXf2HFfD5epTJO/dHUxtXjnKYQtTbUcg8N2KOqKsEwB3TTcPziC9xn1rbXeSlmaZBTLic7tRgW4+T2X/Lqx007wrMhgHP/z+u2U/V1Sy/3tZpjdeDJKoIgnvioubaEVAI9Ex9M3o7cRMLm9iV5qPSoxZWt8iUPXpnsPTvn6zUsG6EtfACMJEInC2o6hkZQnc4fJamMKwBoEGTZZmYnM24kypHFY8/fvvFBV5wZ8eBFRg4Jl1TkiURPn9QivZ415uEIE0D3mqQ
 3Z1/G4Kw
 Z6w9f/PHpJ4ku/ZxXWWlcaeI7P45oL+opYB1LKbi2IGONLRHvFRP7ume24FOiv5DyPB/UdmT4Tw0EDBGn6DJm13I/wclCZUhCeAJai41QyTkgYj3adWWVibD9ZIoCylRmLUDu9HxTIoew+BYInmbT28lxRzDHAVrqqNk1fe/fUClCOKLFU3CLd/9y3Tk5bTO/z+K0XDjtQu+zvtDRSfetiINS0VKR8bIdP6bf/PlFj1hEZI1YqBramdLXCZ3WR75kh4gk/caT+6CHMHQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 05:28:30PM +0800, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>

> +static inline bool swp_tb_is_countable(unsigned long swp_tb)
> +{
> +	return (swp_tb_is_shadow(swp_tb) || swp_tb_is_folio(swp_tb) ||
> +		swp_tb_is_null(swp_tb));
> +}

What do you think about simplifying swp_tb_is_countable by just checking
!swp_tb_is_bad(swp_tb)?

Since this function appears to be called frequently, reducing the number of
comparisons would be beneficial for performance. If validation is
necessary for debugging perhaps we could introduce a separate version for debugging
purposes.

> +static inline int swp_tb_get_count(unsigned long swp_tb)
> +{
> +	if (swp_tb_is_countable(swp_tb))
> +		return __swp_tb_get_count(swp_tb);
> +	return -EINVAL;
>  }

Or, could we simply drop the check in swp_tb_get_count and call
__swp_tb_get_count directly?
If we define SWP_TB_BAD to have 0 in the count bits (MSB), it will
naturally yield a count of 0.

Thanks!
Youngjun Park

