Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02AFD606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nSMN0kNU
Received: by kanga.kvack.org (Postfix)
	id 203FC6B05C0; Wed, 28 Oct 2026 11:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4BE6B05C1; Wed, 28 Oct 2026 11:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1A36B05C2; Wed, 28 Oct 2026 11:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E536E6B05C0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:06:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7695F16010A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:06:24 +0000 (UTC)
X-FDA: 85372361088.20.7415677
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9657920014
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:06:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nSMN0kNU;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793199982;
	b=7oJPWi7Jl2nQX7UnDFxF+oL18Dc8xtK5XfzVt1Eahn+1ZdW6njT67QPdgEc3oEltY7MlAX
	18tkahVar2yDI/hPQgm5j7atxplqeET58NiRKuf0rw5fn6TeR3Om49pUtb6mINuZZCzW/P
	TbRA6Z7eReKV3dFizCqVSHaOb7ziYRk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nSMN0kNU;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793199982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jc1NHj5NVrt4/jNwGZiFo0SWS3JKZ9BEwEfYFaPbfCE=;
	b=D13K6s9iUtqXH/In0QC65/wLvJNT9lSxU3I8iyQCJ+TCiyf9cGxsuVzm1d0gheWrm2Cznz
	QC01IW6Hdie7chi3f7VoQtrJYpGa26CKLHjyaNwqFgNHYQY6LBK7aXrDrMSfPcd9nnwJTZ
	NHad9vaIdQ+OztLHGcLK2R2zlyHw19I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FF2543A65;
	Wed, 28 Oct 2026 15:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D741F01825;
	Wed, 28 Oct 2026 15:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793199981;
	bh=jc1NHj5NVrt4/jNwGZiFo0SWS3JKZ9BEwEfYFaPbfCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nSMN0kNUmbsSHdv9awMBVCH6qjwWaKvcGUVUjLsuOukkXyE8GaNWdnrlzGSOWPUxx
	 nIsSj6zS3F7QsXpgAgCtNpKWs3qPXOfWQaHXjI7q8Xy8+AoZLdOW+kb2R2ariJ14KF
	 kh39GIVq+tFgQWcEXC77GFJzfx3q8MIhkGL8UJIK+0HbuqXpIEj0zsOIpanmvlIs+I
	 XY1CLvSbmqKiZpQM9NT3GWGDqEiJMlgHH68ERZ6/KUve1IBluVECVEYyQ6usMhvjLF
	 1k28ca39gz7anWHNTGkRQgyVUEHbN5YlUmHfrgIOGLQXh3xkTgFAB5SyTFIhCpCTuz
	 s2VKrE5jIpz0Q==
Date: Wed, 28 Oct 2026 15:06:19 +0000
From: Harry Yoo <harry@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>, 
	GONG Ruiqi <gongruiqi@huaweicloud.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Kieran Bingham <kbingham@kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 0/8] mm/slab: Support selecting slab hardening features
 at boot
Message-ID: <auIN44CnAyzvR_Ll@thinkstation>
References: <cover.1793086056.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793086056.git.chris@chrisdown.name>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9657920014
X-Stat-Signature: ogp7b91zmeyorqs86t9bsq3zs4gxn1gp
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793199982-754941
X-HE-Meta: U2FsdGVkX19Pu/XcGezModtJR7pgL5cSvbCuoqv8AhMCm2NNTp1B7OOfB6LvVb84f/OFxQwUnUqnLeP3pEqY1qmrPkg88pwrNW+rNB0I2qrX4GlWjrUVTVh17Js/VMP2XQJW117hZpp9ywuH+htrws4gY8WJz4tn0f71z/URfsaw7s83XG+z6JrxTZshQqfjpyGYn3ImsLsh9fM5Uttu7hwxskKhBZXm/GBsUNOeIgmoGFWUJ5x/YbV7e/Y4b4f2w+BIb0RBGkgzS0RmZ3WbLYKFdJNJKXZTmd9d+UXO2QRGwcK99j8PJUWYReBu2+ryyiC0tRHpzY0kxGYHe/ZYaOOtaNDOM6GyDfBRDj14WS+y0TcKmO2C7D6qwQc4PoywZi/F6lt+W84bCHLpIMyCSapMlZFDJ9ZI84Su48xdMezuRlJdGRj8pQ9JiUOCAOFPW5TExETv4Cb8SHmZGoXbRZGx7Mn23JK1p+JfngjKIQX8Kzo+Ump0B5/B1ZJL8/LD6PEnLprIvHwFuYB9nMsAFNHQiRSthai95kvEE79b53ajMy05yyveD2NLs1vU2P+abIlMPHQVktICGAg4rpE5312d5ajrzuST8gkwqQimv9SYLeN6Yp4MR5RGx9GPpQTiGmFsII95E5DnxKggFErVHneVEA9uH1J9/oA0TmRwGwGeHcXX7ZzTpGjHlG3pgYAfk/aG/0Y1dgg3KKMw4ZLtZugSdrRUSaK1L8XCAPA+iYms16YuA34zDYAm3s6mtTVG1Jl8ctMdSp17pk0kK0h5jpHSK7dCE8BgC7qXVgnzyTM20lZTSfAKohaDBezmshd8y+r0RQHw4JPosFd1U+22EVvg5BdTJPtvTTeIs+NBll+q69a1M7KVPX4sxRgVZgw2Ue4E/K5tB71WvRJKLkE0yC6TLeXODc2FqNLbrywwXlwLJei3jvCsLyTNHmA9sQ3182cn5qgSOpojCjB4CtM
 d67gaWsT
 vHow8DiAmuONueJkHY0X2Hwz7Hl/2hxdlBuTjhNb04FwvHphzmVrgdKuqp0qLhfDAG7zHs7m1VAwd8a2Zc3meq4MpDkiGsQ+NQf04kiGSDbozuefQbMAc+rraoU3QVuuhK3tWVDO86iAQPes3EkOzw4Kv446MIx16LHDD0llRArSKhhsNi7ReOdtSPozqiHi3UWVTvyd/wMG0b0KfBAcBByceWVzpl/a+6GyaLP9tMAGv2904ve4lrMDmWwwmWlGnhNvNl6x+ksKDOzOvLB/mPf31nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Chris!

On Tue, Oct 27, 2026 at 03:35:16PM +0800, Chris Down wrote:
> Slab hardening settings are currently all build time choices. This means
> that, unfortunately, hosts with different requirements end up needing
> separate kernel images. Let's allow those hosts to use one image and
> select each policy at boot instead.
> 
> This series adds four new boot parameters that default to their values
> from CONFIG_*:
> 
>   slab_freelist_hardened=
>   slab_freelist_random=
>   slab_buckets=
>   kmalloc_partition=

If we end up supporting boot-time parameters for hardening,
I think it should be all enabled (or disabled) by:

  slab_hardening=none|light|full
  # please feel free to suggest bertter names

none: "Turn of all of them to maximize performance"

light: "I'm willying to sacrifice _some_ memory and CPU for security"

full: "I'm willying to sacrifice more overhead for security

IMHO more fine-grained knob for each feature doesn't make much sense.

-- 
Cheers,
Harry / Hyeonggon

