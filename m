Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 419E3C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3008A6B0088; Thu, 27 Aug 2026 12:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0C16B00A0; Thu, 27 Aug 2026 12:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED566B00A3; Thu, 27 Aug 2026 12:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC5EB6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:47:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77339C0131
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:47:15 +0000 (UTC)
X-FDA: 85147629630.25.7AB81F5
Received: from mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	by imf14.hostedemail.com (Postfix) with ESMTP id 25DF7100005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:47:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cdqoNWQw;
	spf=pass (imf14.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787849233;
	b=qgi5ijNlMMgUKXfOCa2OkCDH6Y7BYUuvS5Qgg6U5SLFQJGIWT1OC1e82HFOQ/7woCENAs3
	jJDCG64xMIkiHGru/lSNgMomRksNx5zD8uGUB9PlpOR+0zRKrwuhkthqMNuknOYq+hzw8Z
	6ftgoLBs92D3p8G8AObsjZwEkC3sZUg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cdqoNWQw;
	spf=pass (imf14.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787849233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70IFeI9DuJtw07Cv6XNyy1SCo9uheOn6JyfiHfrUVJQ=;
	b=rQsDsM7jB146qOM5d3x+eBCk0J5rXwe/uoo4xS/gBGJZMWhqSMGGA9b0Yj9O2V9bsntDhZ
	RJ9m6HGzBNRUato302l8gwq1VUBJ9R/Usf7P29eJNl2XBwPkW2zskbSam3Ps5X6yUMBA4T
	1lE9bu/mcbhEvSVSkAAGKHCvh8feAo0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ptF/ax/1jZdDt8j5oFLsGrhLay+63QE59Z755eP1/VM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787849231; v=1; x=1788454031;
 b=cdqoNWQwGE4pw7YaEc9+Z4A8iIJ2xOp+9g1cUgA1yJoa2gxzxKwXIFbho1iL4ZHPPMB4VVp/
 2yG4NIKB99aaiUAIoMTLveJkSCtbPDQtFkXtIw0oz/jNEbM4UDzeHZ9/cij0FOEWZYoMvo1etI2
 fvjo57CCzcTaOkkrfQNHWKe0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9791eedcd5c3b768;
	Thu, 27 Aug 2026 16:47:11 +0000
X-Mizu-Trace-ID: 9791eedcd5c3b768
X-Migadu-Flow: FLOW_OUT
Message-ID: <72252089-0405-441a-a7dc-0e1deeb2f802@linux.dev>
Date: Fri, 28 Aug 2026 00:47:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/core: remove declaration of kdamond_fn()
To: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: sj@kernel.org, akpm@linux-foundation.org
References: <20260827163953.83520-1-zenghui.yu@linux.dev>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260827163953.83520-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: wyait9wua8bs5md93hmfieoagbkktaxm
X-Rspamd-Queue-Id: 25DF7100005
X-Rspamd-Server: rspam06
X-HE-Tag: 1787849232-123437
X-HE-Meta: U2FsdGVkX1+R7tB9mzTq5BYg8WjsRg/7OgaFWr9frCHWvYXgC/IeZBPPSLhmALfP/Q+jkqkIxIKPRDORw5BD92v/ueC7RID7tZ4mxSfmrvr4IOeFtJBQpYxDKr+49CmO7ymYu86rxkfi+xU4gA3h4uI6rEmlqNEbh3pSSYA5c8bqs8hhZs9J/+057PB4Ug3u/eHbkknf7tmBM7GO1HyD6nzdo+fVbp2ezMoRUGUylwfwlKhzX9BM62Q+pEPvOtPP2YmB7J62hgLAmqD+HBHS42W04JHSFxYSez2xQi3vSQK0QRKFzUGZcynAooVSORKQ9h0fts1umxoEUULcITNUi/7NzL4JYKfPvQfZ7wGkbE4Rpt4P1eaN4/nOfJiQPhCvUwmnGWdZKW+712Ymb55RhWhCiYQIP7XoPmBSWBDKvep260MaG/gXc6oQWBHTl/NTyXB3es1FcNjAM8opJwzyUEmoSXvnf16XhlX/XmCc+JY/dER3sCtVfNC3Sz+5JuTqFVvfR8aUodGK+AGopOWocghpVcz3d6TR3XeV1RtPkhbZOQDRvYa0fTZg6K3iooIeZ6q6qohnu7qLFTa4InVij9grq/W4efGn4/u1OWDBGJw3uM8ynOWHNUNPzZNyxIE9OpVp3bg0jyI4YUxXxTA7wN0JAYNxWvps1Bz/vB2AM2/CgrqzB46WE+7M9mU+YENtbUYQm6cTMcs2UJCgKZwosUmq/0cEj/Oga0Hu2stdfutxhbtxyjnKI8QHcAyvtyJpbkBzxo0U4xTS4S5Yeor+8MJDKqurEepekhv1rZr0MFJoesAGMA4TM0yvK9qWelpt0Roi6eHnVQBqO0p6juMVd1LEzC3KsuAvQWtadC40N2/BxbGnTzWOfmlLSCl3o14UQ1XBrjXLlicn+lYwTnFhGXaotBORc1kPrzNAQH3Keeo8rNRzvYM322YUZf400+R/xo454DkUgQLh/x/Fw5P
 BB9M0g3U
 WNDphi6GUcTvNaFV1JGVLpVfAq+15ZUmbm3xw991VcjovtbdyRIBjv56zEX/LIQml5Fv7wAxXMRS0Fq6mNEVwXEHnFQYFRRekG8JgP1JocThHHvMeCxFtfumRZAsdS/l8DvemoD7d2AN7zq4LGcLbIlKh/ne5hdd5pXcoArzBB936EWKp97oqTQp6UddqflmnM+x3D2nK163MeaoHSqiQ5OIj1ui9DfbxWmOITuZUt1/yY+cqTjWMZvXm5a338zFNsyW2RtZyXLczshG5NQGqF6zdIpWnSkMyiwWp9shvApfXEpFyax6J1ykvSbRDLP76vGSG6bg1MVOQ9d6lnuQNDBGtFqPaNUd1i7S0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please ignore this patch.  This is absolutely wrong.  Sorry for the noise..

On 8/28/26 12:39 AM, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> It was added by commit 2224d8485492 ("mm: introduce Data Access MONitor
> (DAMON)") but is actually not needed.  Remove it.
> 
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---
>  mm/damon/core.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 37d661e2bbc1..183080556404 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1922,8 +1922,6 @@ static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
>  	return max_region_sz;
>  }
>  
> -static int kdamond_fn(void *data);
> -
>  /*
>   * __damon_start() - Starts monitoring with given context.
>   * @ctx:	monitoring context


