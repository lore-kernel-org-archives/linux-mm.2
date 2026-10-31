Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DF43606A336
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 04:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GIbmAu2e
Received: by kanga.kvack.org (Postfix)
	id 3C47D6B05B1; Sat, 31 Oct 2026 00:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375C46B05B2; Sat, 31 Oct 2026 00:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23F4C6B05B3; Sat, 31 Oct 2026 00:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00D8F6B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:29:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 792181608E8
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:29:29 +0000 (UTC)
X-FDA: 85381642458.30.10088E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D8A5720002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:29:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GIbmAu2e;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793420967;
	b=u46XN54wv2ixuXpvTc6wmUZFT7mQKEI4JC6Cx8d/PPc5ZN/wP2toRiGu6xzPmE2DQ1orWd
	aA/XRLd788bC/sbc09KJiypM2cEkw7wRx3tebNJ1uRW1PXvrLgZuau3Q+u3i8UFmjdZ39W
	fsHfkYvtQPPiK5XAq9zaurVt+zxmT6Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GIbmAu2e;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793420967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+AT69Pw/D+atv5Rt7qE2T+LpdzYoQhnYrr78IvOD04=;
	b=wR0W6bSnMH8XjWBTdL+mtgMAk3SP2IpGyACYqi4STN30sF6U3nwFt9DH70r2zwu5mmyzUI
	Eze8egpiC2I9Wlav54Zib8A6eifiC0ce6YJpDzGG6kX5yMy3unaufMN322eh8oN43Z2u7W
	GbUMk61R2zkaTR3VJzgj3MGHJyuYZx4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 271BE4073E;
	Sat, 31 Oct 2026 04:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095F61F000C1;
	Sat, 31 Oct 2026 04:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793420967;
	bh=F+AT69Pw/D+atv5Rt7qE2T+LpdzYoQhnYrr78IvOD04=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GIbmAu2exceR1uIZTs7rl2hC9kygOoZXYd8Y3qH3jGjd4i5fI3QDnM2lcqs9KMCUN
	 YtMrTP4XFTnOfdTfApE23z7YrJKGmPa/0L2iqHqPAga76lEMtHAWbXHPlsThGMi2Nu
	 QKjGT3muQdoirvHhGTIzTZayNmDTMt1ZJMEqTw79Z4/mG/whx3uGZuYeWv6Sr+wmrw
	 ASU/rpCy65bePqmVh9v6vYlRIoaADrtJLpevDq3BNlJD/3OO4/A88oBPdYLH7h2gHY
	 dn64zja+WxpOFshJ/S9FsE258ABtIForRe37CdrQFzdtZCuaBOtbsgJNjR2s6kk5az
	 4UDq9XtL57X4Q==
Date: Fri, 30 Oct 2026 21:29:26 -0700
From: Kees Cook <kees@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] slub_kunit: Add a test for the kmalloc_partition
 boot parameter
Message-ID: <202610302128.1009F254@keescook>
References: <cover.1793253633.git.chris@chrisdown.name>
 <66f981ce04dfb01d02d1683bb18ba6db1c4eabd1.1793253633.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66f981ce04dfb01d02d1683bb18ba6db1c4eabd1.1793253633.git.chris@chrisdown.name>
X-Rspam-User: 
X-Rspamd-Queue-Id: D8A5720002
X-Stat-Signature: rtsqxtoxu4i9nxmzh1entqs8jnc7tuzw
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793420967-701799
X-HE-Meta: U2FsdGVkX18nSsvgVkEvGpphz6kZtrM1Txutxbuh5bLGhJ37FHS34+MY4ULIQP5BvyG78lSxNPH/zF2blpmjiMfcS4d4U+x+ETRNt6xpHUkKzoBJnSmBW94z+VOTjCKT6gIV1iccnCPPmzIcvwJWqY+R5pAS/ZWidFRr999QmQ0yFCtrLhP2iTGapfrTqbJsWeeeq7dVrMhgp+Qo1237XtNMyd0uMB+HcfVV4C2V2JKR8oeMwBKafRcHhUvl2aKWwxQxHMC56a2ljLV4Sxlr7omN0R4UiVYDiwa0GdNpwoQMxDf0/VRvD25wVAeKYwavB811kEzzk7xt1ou3MGPLQq+ZT78xya+7F4lalNqMDn9c8F5Kq9YMDgjekQg7tU2zbsk+OyT94uHg71/OVBA3kAxtmXgrVBDJjrU9GMPyoWsgK88WSJqR+gtROju7OhJIWanyrm9rKyomZE1ktn2lKf91NWCYdcWhl7/5M9lUz/7dxUHJ5eqnx0ldRLXeujkywQyvPUH8kmkevokwgKP99mshYTpSYJaVJiyCY8f6HscApBgTI7ks8vJa/CQi0lP4PaDGutjYGOXJr9lCfDxsrNbgADUW1ZGN7vpjYByq4YSD7tvfukTws7yB4XYMz1As6tK5tHKKTxDh6UXjAFMqKwqMz2Jm1wnp/oWCYqJtovGhN2UfOmbAXTltemFSo3Dgg/xJa8m7diFNp+9KTceuYcPftw/6woVZcy1VMnUx/yWorbW9dRZjqQwMUaeM1hsNN8FdTyTH+WurzPP5H6AsYuZCC7ZERp5EIJ4SLXuupOk4Tv9FaYVYmm/kNwAH2MEmei4PVBEWm1cC2NkjR6WMtndobDErVIm/4uBRwS1/0+wfYVlEJSvtwaeHFGZhZDebfgxYV6TsuFheeUQav4dh80AaowA/c3DXoqJExL/8AjP33TewgMClxH369pqbHp1zRT3FCYRsMttQLYu2Dxk
 mki8WgZE
 MM7likb93inNjfKC6oGyfn3OuWPlzQ/ZeC58qjG2MQv67rnCKNY80sIhHh07ZxUt3WNiAimTtQoTIhXy5E0xu6HqP64H7+IK/LQLa4ULfAayrjN9TmaEBDskr45AtBYlw0uFFmRUnoesr3hpvP58hdNXJKwqoJN2tYu+NS/8PaJhsb/bNE34z1YEsK18wYn7t4IgGM7znXukngK0EkRvItcA4YGttQFLTjcaw5+AsBT0iyCaXW9YuwzOZIWyqy6Jnc3wvbrVkFqjz168kUotUJOJFaOsmwTXI/WIAYYPc8GH2XFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 02:09:21PM +0800, Chris Down wrote:
> Check that the kmalloc partitions are separate caches by default, and
> alias the normal kmalloc caches when they're turned off with
> kmalloc_partition=0.
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  lib/tests/slub_kunit.c | 46 ++++++++++++++++++++++++++++++++++++++++++
>  mm/slab.h              |  4 ++++
>  mm/slab_common.c       |  3 ++-
>  3 files changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
> index 670645875b27..e3035864577d 100644
> --- a/lib/tests/slub_kunit.c
> +++ b/lib/tests/slub_kunit.c
> @@ -333,6 +333,49 @@ static void test_slab_buckets(struct kunit *test)
>  }
>  #endif
>  
> +#ifdef CONFIG_KMALLOC_PARTITION_CACHES

Same feedback as the other test: let's get rid of all this ifdef-ery :)

-- 
Kees Cook

